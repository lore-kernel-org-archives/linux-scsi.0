From: Neil Horman <nhorman@redhat.com>
Subject: Re: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 15:08:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415B0841.8010009@redhat.com>
References: <20040929161345.GB22308@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18120 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S267360AbUI2TJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:09:35 -0400
In-Reply-To: <20040929161345.GB22308@beardog.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Cc: marcelo.tosatti@cyclades.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, brian.b@hp.com

mike.miller@hp.com wrote:
> Currently cciss statistics are not collected in /proc/stat. This patch
> bumps DK_MAX_MAJOR to 111 to fix that. This has been a common complaint
> by customers wishing to gather info about cciss devices.
> Please consider this for inclusion. Applies to 2.4.28-pre3.
> 
> Thanks,
> mikem
> -------------------------------------------------------------------------------
> 
> diff -burNp lx2428-pre1.orig/include/linux/kernel_stat.h lx2428-pre1/include/linux/kernel_stat.h
> --- lx2428-pre1.orig/include/linux/kernel_stat.h	2004-08-23 15:41:43.640300000 -0500
> +++ lx2428-pre1/include/linux/kernel_stat.h	2004-08-23 15:43:07.097613064 -0500
> @@ -12,7 +12,7 @@
>   * used by rstatd/perfmeter
>   */
>  
> -#define DK_MAX_MAJOR 16
> +#define DK_MAX_MAJOR 111
>  #define DK_MAX_DISK 16
>  
>  struct kernel_stat {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
The answer to this is to use the latest sysstat tools.  the latest 
version of iostat, sar, etc draw information out of /proc/partitions 
rather than out of /proc/stat.  Or are you using some other home rolled 
tool in this case?

Neil

-- 
/***************************************************
  *Neil Horman
  *Software Engineer
  *Red Hat, Inc.
  *nhorman@redhat.com
  *gpg keyid: 1024D / 0x92A74FA1
  *http://pgp.mit.edu
  ***************************************************/

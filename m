From: Neil Horman <nhorman@redhat.com>
Subject: Re: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 15:39:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <415B0F85.3090808@redhat.com>
References: <D4CFB69C345C394284E4B78B876C1CF107DBFE1A@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2011 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S268900AbUI2TkC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:40:02 -0400
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF107DBFE1A@cceexc23.americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <mike.miller@hp.com>
Cc: mikem@beardog.cca.cpqcorp.net, marcelo.tosatti@cyclades.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Baker, Brian (ISS - Houston)" <brian.b@hp.com>

Miller, Mike (OS Dev) wrote:
>>mike.miller@hp.com wrote:
>>
>>>Currently cciss statistics are not collected in /proc/stat. 
>>
>>This patch
>>
>>>bumps DK_MAX_MAJOR to 111 to fix that. This has been a 
>>
>>common complaint
>>
>>>by customers wishing to gather info about cciss devices.
>>>Please consider this for inclusion. Applies to 2.4.28-pre3.
>>>
>>>Thanks,
>>>mikem
>>>
>>
>>--------------------------------------------------------------
>>-----------------
>>
>>>diff -burNp lx2428-pre1.orig/include/linux/kernel_stat.h 
>>
>>lx2428-pre1/include/linux/kernel_stat.h
>>
>>>--- lx2428-pre1.orig/include/linux/kernel_stat.h	
>>
>>2004-08-23 15:41:43.640300000 -0500
>>
>>>+++ lx2428-pre1/include/linux/kernel_stat.h	2004-08-23 
>>
>>15:43:07.097613064 -0500
>>
>>>@@ -12,7 +12,7 @@
>>>  * used by rstatd/perfmeter
>>>  */
>>> 
>>>-#define DK_MAX_MAJOR 16
>>>+#define DK_MAX_MAJOR 111
>>> #define DK_MAX_DISK 16
>>> 
>>> struct kernel_stat {
>>>-
>>>To unsubscribe from this list: send the line "unsubscribe 
>>
>>linux-kernel" in
>>
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>Please read the FAQ at  http://www.tux.org/lkml/
>>
>>The answer to this is to use the latest sysstat tools.  the latest 
>>version of iostat, sar, etc draw information out of /proc/partitions 
>>rather than out of /proc/stat.  Or are you using some other 
>>home rolled 
>>tool in this case?
>>
>>Neil
> 
> 
> It's customers that are doing this. I think some of them are using their own tools. Others are probably using whatever comes on their distro.
> 
> mikem
> 
They should probably upgrade their tools, be they from the distro or 
their own (It was my understanding that /proc/stat was depricated and 
going to be removed in the not-to-distant future).

Neil

> 
>>-- 
>>/***************************************************
>>  *Neil Horman
>>  *Software Engineer
>>  *Red Hat, Inc.
>>  *nhorman@redhat.com
>>  *gpg keyid: 1024D / 0x92A74FA1
>>  *http://pgp.mit.edu
>>  ***************************************************/
> 
> 


-- 
/***************************************************
  *Neil Horman
  *Software Engineer
  *Red Hat, Inc.
  *nhorman@redhat.com
  *gpg keyid: 1024D / 0x92A74FA1
  *http://pgp.mit.edu
  ***************************************************/

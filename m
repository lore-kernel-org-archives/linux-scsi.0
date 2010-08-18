From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] fusion: fix non-kernel-doc comment block
Date: Wed, 18 Aug 2010 17:39:53 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029923AB36@inbmail02.lsi.com>
References: <20100814130550.bc3cc5e6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:52187 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab0HRMKD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 08:10:03 -0400
In-Reply-To: <20100814130550.bc3cc5e6.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>

Acked this patch.

~Kashyap


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Randy Dunlap
> Sent: Sunday, August 15, 2010 1:36 AM
> To: scsi
> Cc: Moore, Eric; torvalds; akpm
> Subject: [PATCH] fusion: fix non-kernel-doc comment block
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix comment begin notation not to look like kernel-doc
> since it's not.  Removes kernel-doc warnings.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/message/fusion/mptbase.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.35-git15.orig/drivers/message/fusion/mptbase.c
> +++ linux-2.6.35-git15/drivers/message/fusion/mptbase.c
> @@ -6560,7 +6560,7 @@ procmpt_destroy(void)
>  }
> 
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=*/
> -/**
> +/*
>   *	Handles read request from /proc/mpt/summary or
> /proc/mpt/iocN/summary.
>   */
>  static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct
> seq_file *m, int showlan);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

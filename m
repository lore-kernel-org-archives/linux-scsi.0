From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscim: Remove unused SCSI_IRQ_NONE macro definition
Date: Thu, 16 Oct 2014 21:12:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1410162109160.16927@axis700.grange>
References: <alpine.LNX.2.00.1410011654020.25690@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63293 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaJPTMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2014 15:12:30 -0400
In-Reply-To: <alpine.LNX.2.00.1410011654020.25690@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, trivial@kernel.org

On Fri, 3 Oct 2014, Finn Thain wrote:

> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
> ---
> 
> This macro is only used in the NCR5380 drivers and they don't include
> this header.
> 
> ---
>  drivers/scsi/tmscsim.h |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: linux/drivers/scsi/tmscsim.h
> ===================================================================
> --- linux.orig/drivers/scsi/tmscsim.h	2014-09-29 10:55:44.000000000 +1000
> +++ linux/drivers/scsi/tmscsim.h	2014-10-01 16:33:25.000000000 +1000
> @@ -10,8 +10,6 @@
>  
>  #include <linux/types.h>
>  
> -#define SCSI_IRQ_NONE 255
> -
>  #define MAX_ADAPTER_NUM 	4
>  #define MAX_SG_LIST_BUF 	16	/* Not used */
>  #define MAX_SCSI_ID		8
> 

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] remove some dead code in qla2xxx
Date: Tue, 19 Apr 2005 00:32:40 -0700
Message-ID: <20050419073240.GE5999@plap.qlogic.org>
References: <20050418130334.GA30034@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:7590 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261376AbVDSHcm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 03:32:42 -0400
Content-Disposition: inline
In-Reply-To: <20050418130334.GA30034@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Mon, 18 Apr 2005, Christoph Hellwig wrote:

> 
> ===== drivers/scsi/qla2xxx/qla_dbg.c 1.12 vs edited =====
> --- 1.12/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-13 17:45:53 +02:00
> +++ edited/drivers/scsi/qla2xxx/qla_dbg.c	2005-04-18 16:22:48 +02:00
> @@ -1063,8 +1063,7 @@
>  		return;
>  
>  	printk("  sp flags=0x%x\n", sp->flags);
> -	printk("  r_start=0x%lx, u_start=0x%lx, f_start=0x%lx, state=%d\n",
> -	    sp->r_start, sp->u_start, sp->f_start, sp->state);
> +	printk("  state=%d\n", sp->state);
>  }
>  
...

Good stuff, I had a (more conservative) patchset in the queue which
began to prune most of the stuff you've wacked with your patch.

Seems reasonable, I'll run it through my test ring tomorrow and ACK
when all looks good.

Thanks,
Andrew Vasquez

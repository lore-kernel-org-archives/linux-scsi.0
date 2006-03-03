From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [SCSI] Fix missing prototypes by including <linux/interrupt.h>.
Date: Fri, 3 Mar 2006 08:25:06 -0700
Message-ID: <20060303152506.GL1598@parisc-linux.org>
References: <20060303152148.GA10566@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38618 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932154AbWCCPZI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 10:25:08 -0500
Content-Disposition: inline
In-Reply-To: <20060303152148.GA10566@linux-mips.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 03, 2006 at 03:21:48PM +0000, Ralf Baechle wrote:
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index fb53eea..cd06e69 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -78,6 +78,7 @@
>  #include <linux/string.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
> +#include <linux/interrupt.h>
>  #include <linux/blkdev.h>
>  #include <asm/irq.h>

If you're adding linux/interrupt.h, you should probably remove the
asm/irq.h since it'll be pulled in through asm/hardirq.h

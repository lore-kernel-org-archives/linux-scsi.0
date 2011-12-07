From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: mark some messages as INFO/WARNING/ERROR
Date: Wed, 07 Dec 2011 09:32:42 -0800
Message-ID: <1323279162.1762.51.camel@joe2Laptop>
References: <1323276754-1744-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323276754-1744-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Gundersen <teg@jklm.no>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-12-07 at 17:52 +0100, Tom Gundersen wrote:
> This reduces the noice
[]
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
[]
> @@ -416,7 +416,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>  		if (!in_interrupt())
>  			sr_set_blocklength(cd, 2048);
>  		else
> -			printk("sr: can't switch blocksize: in interrupt\n");
> +			printk(KERN_WARNING "sr: can't switch blocksize: in interrupt\n");

Maybe this should be KERN_ERR?

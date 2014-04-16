From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/8] blk-mq: bidi support
Date: Wed, 16 Apr 2014 10:41:30 -0600
Message-ID: <534EB2BA.7020705@kernel.dk>
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-3-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/16/2014 01:44 AM, Christoph Hellwig wrote:
> diff --git a/block/bsg.c b/block/bsg.c
> index 420a5a9..2956086 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -1008,7 +1008,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
>  	/*
>  	 * we need a proper transport to send commands, not a stacked device
>  	 */
> -	if (!q->request_fn)
> +	if (!q->request_fn && !q->mq_ops)
>  		return 0;
>  
>  	bcd = &q->bsg_dev;

This looks misplaced. But I dropped the one I generated last week, I'll
queue it up separately in the drivers branch.

-- 
Jens Axboe

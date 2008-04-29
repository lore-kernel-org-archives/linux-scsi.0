From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix compile warning
Date: Tue, 29 Apr 2008 09:55:15 +0200
Message-ID: <20080429075515.GG12774@kernel.dk>
References: <20080426013746Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2447 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYD2HzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 03:55:18 -0400
Content-Disposition: inline
In-Reply-To: <20080426013746Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sat, Apr 26 2008, FUJITA Tomonori wrote:
> This is against Jens' for-linus branch.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: fix compile warning
> 
> block/blk-core.c: In function __blk_run_queue
> block/blk-core.c:382: warning: unused variable flags
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  block/blk-core.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 35ae1c0..4fd42af 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -380,8 +380,6 @@ EXPORT_SYMBOL(blk_sync_queue);
>   */
>  void __blk_run_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
>  	blk_remove_plug(q);
>  
>  	/*
> -- 
> 1.5.4.2

Thanks Tomo!

-- 
Jens Axboe


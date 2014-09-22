From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: fix blk_abort_request on blk-mq
Date: Mon, 22 Sep 2014 08:08:19 -0600
Message-ID: <54202D53.4090202@kernel.dk>
References: <1411394371-16254-1-git-send-email-hch@lst.de> <1411394371-16254-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43413 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaIVOIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 10:08:23 -0400
Received: by mail-pd0-f180.google.com with SMTP id r10so4478804pdi.11
        for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2014 07:08:23 -0700 (PDT)
In-Reply-To: <1411394371-16254-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 2014-09-22 07:59, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-mq.c      | 2 +-
>   block/blk-timeout.c | 5 ++++-
>   block/blk.h         | 2 ++
>   3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk.h b/block/blk.h
> index e515a28..159e973 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -250,4 +250,6 @@ static inline int blk_throtl_init(struct request_queue *q) { return 0; }
>   static inline void blk_throtl_exit(struct request_queue *q) { }
>   #endif /* CONFIG_BLK_DEV_THROTTLING */
>
> +extern void blk_mq_rq_timed_out(struct request *req, bool reserved);

Moving this to blk-mq.h.

Applied.

-- 
Jens Axboe


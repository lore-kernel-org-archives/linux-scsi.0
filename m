From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Mon, 17 Oct 2016 09:29:37 +0200
Message-ID: <20161017072937.iaihqmjrodbsyxew@linux-x5ow.site>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
 <1476521241-32765-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757465AbcJQH3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 03:29:40 -0400
Content-Disposition: inline
In-Reply-To: <1476521241-32765-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, don.brace@microsemi.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Sat, Oct 15, 2016 at 10:47:19AM +0200, Christoph Hellwig wrote:
> This will allow SCSI to have a single blk_mq_ops structure that either
> lets the LLDD map the queues to PCIe MSIx vectors or use the default.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.h         | 1 -
>  include/linux/blk-mq.h | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index e5d2524..5347f01 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -38,7 +38,6 @@ void blk_mq_disable_hotplug(void);
>  /*
>   * CPU -> queue mappings
>   */
> -int blk_mq_map_queues(struct blk_mq_tag_set *set);
>  extern int blk_mq_hw_queue_to_node(unsigned int *map, unsigned int);
>  
>  static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 535ab2e..6c0fb25 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -237,6 +237,7 @@ void blk_mq_unfreeze_queue(struct request_queue *q);
>  void blk_mq_freeze_queue_start(struct request_queue *q);
>  int blk_mq_reinit_tagset(struct blk_mq_tag_set *set);
>  
> +int blk_mq_map_queues(struct blk_mq_tag_set *set);
>  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
>  
>  /*
> -- 
> 2.1.4

See comment on patch 2, otherwise
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

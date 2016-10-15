From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Sat, 15 Oct 2016 13:45:50 +0200
Message-ID: <274accbb-ee64-706d-1942-183194ed34de@suse.de>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
 <1476521241-32765-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752447AbcJOLpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Oct 2016 07:45:52 -0400
In-Reply-To: <1476521241-32765-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On 10/15/2016 10:47 AM, Christoph Hellwig wrote:
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
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

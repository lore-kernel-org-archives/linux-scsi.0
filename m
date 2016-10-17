From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/3] scsi: allow LLDDs to expose the queue mapping to
 blk-mq
Date: Mon, 17 Oct 2016 09:27:03 +0200
Message-ID: <20161017072703.jql7gbmbnsfed4n3@linux-x5ow.site>
References: <1476521241-32765-1-git-send-email-hch@lst.de>
 <1476521241-32765-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476521241-32765-3-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, don.brace@microsemi.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 15, 2016 at 10:47:20AM +0200, Christoph Hellwig wrote:
> Just hand through the blk-mq map_queues method in the host template.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq-cpumap.c    |  1 +
>  drivers/scsi/scsi_lib.c  | 10 ++++++++++
>  include/scsi/scsi_host.h |  8 ++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 19b1d9c..8e61e86 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -87,6 +87,7 @@ int blk_mq_map_queues(struct blk_mq_tag_set *set)
>  	free_cpumask_var(cpus);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(blk_mq_map_queues);
>  
>  /*
>   * We have no quick way of doing reverse lookups. This is only used at

Shouldn't this hunk go into the previous patch?

Otherwise,

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

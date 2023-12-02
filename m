Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FF51B2;
	Fri,  1 Dec 2023 23:21:07 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Sj1Yp336vz4f3jqw;
	Sat,  2 Dec 2023 15:21:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 636181A0B81;
	Sat,  2 Dec 2023 15:21:03 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDn6hDd2mpl_KIRCg--.47253S3;
	Sat, 02 Dec 2023 15:21:03 +0800 (CST)
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Keith Busch <kbusch@kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, Ed Tsai <ed.tsai@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20231130193139.880955-1-bvanassche@acm.org>
 <20231130193139.880955-2-bvanassche@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <58f50403-fcc9-ec11-f52b-f11ced3d2652@huaweicloud.com>
Date: Sat, 2 Dec 2023 15:21:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231130193139.880955-2-bvanassche@acm.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDn6hDd2mpl_KIRCg--.47253S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCry8KFWrXry3ur15GFyfJFb_yoW7Gr15pF
	4DKa15K3y2q348XFWfta13uF1fWrs7Gr1UKrWag345Ars0kFs2qr1ktrWUXrW0vrZ5Crsr
	CrZ8XrykCr1UWrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2023/12/01 3:31, Bart Van Assche Ð´µÀ:
> The fair sharing algorithm has a negative performance impact for storage
> devices for which the full queue depth is required to reach peak
> performance, e.g. UFS devices. This is because it takes long after a
> request queue became inactive until tags are reassigned to the active
> request queue(s). Since making tag sharing fair is not needed if the
> request processing latency is similar for all request queues, introduce
> a function for configuring fair tag sharing. Increase
> BLK_MQ_F_ALLOC_POLICY_START_BIT to prevent that the fair tag sharing
> flag overlaps with the tag allocation policy.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Yu Kuai <yukuai1@huaweicloud.com>
> Cc: Ed Tsai <ed.tsai@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-mq-debugfs.c |  1 +
>   block/blk-mq.c         | 28 ++++++++++++++++++++++++++++
>   block/blk-mq.h         |  3 ++-
>   include/linux/blk-mq.h |  6 ++++--
>   4 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 5cbeb9344f2f..f41408103106 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -198,6 +198,7 @@ static const char *const hctx_flag_name[] = {
>   	HCTX_FLAG_NAME(NO_SCHED),
>   	HCTX_FLAG_NAME(STACKING),
>   	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
> +	HCTX_FLAG_NAME(DISABLE_FAIR_TAG_SHARING),
>   };
>   #undef HCTX_FLAG_NAME
>   
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b8093155df8d..206295606cec 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4569,6 +4569,34 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
>   }
>   EXPORT_SYMBOL(blk_mq_free_tag_set);
>   
> +/*
> + * Enable or disable fair tag sharing for all request queues associated with
> + * a tag set.
> + */
> +void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable)
> +{
> +	const unsigned int DFTS_BIT = ilog2(BLK_MQ_F_DISABLE_FAIR_TAG_SHARING);
> +	struct blk_mq_hw_ctx *hctx;
> +	struct request_queue *q;
> +	unsigned long i;
> +
> +	/*
> +	 * Serialize against blk_mq_update_nr_hw_queues() and
> +	 * blk_mq_realloc_hw_ctxs().
> +	 */
> +	mutex_lock(&set->tag_list_lock);
I'm a litter confused about this comment, because
blk_mq_realloc_hw_ctxs() can be called from
blk_mq_update_nr_hw_queues().

If you are talking about blk_mq_init_allocated_queue(), it looks like
just holding this lock is not enough?
> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
> +		blk_mq_freeze_queue(q);
> +	assign_bit(DFTS_BIT, &set->flags, !enable);
> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
> +		queue_for_each_hw_ctx(q, hctx, i)
> +			assign_bit(DFTS_BIT, &hctx->flags, !enable);
> +	list_for_each_entry(q, &set->tag_list, tag_set_list)
> +		blk_mq_unfreeze_queue(q);
> +	mutex_unlock(&set->tag_list_lock);
> +}
> +EXPORT_SYMBOL(blk_mq_update_fair_sharing);
> +
>   int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>   {
>   	struct blk_mq_tag_set *set = q->tag_set;
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index f75a9ecfebde..eda6bd0611ea 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -416,7 +416,8 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>   {
>   	unsigned int depth, users;
>   
> -	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
> +	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
> +	    (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING))
>   		return true;
>   
>   	/*
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 1ab3081c82ed..ddda190b5c24 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -503,7 +503,7 @@ struct blk_mq_tag_set {
>   	unsigned int		cmd_size;
>   	int			numa_node;
>   	unsigned int		timeout;
> -	unsigned int		flags;
> +	unsigned long		flags;
>   	void			*driver_data;
>   
>   	struct blk_mq_tags	**tags;
> @@ -662,7 +662,8 @@ enum {
>   	 * or shared hwqs instead of 'mq-deadline'.
>   	 */
>   	BLK_MQ_F_NO_SCHED_BY_DEFAULT	= 1 << 7,
> -	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
> +	BLK_MQ_F_DISABLE_FAIR_TAG_SHARING = 1 << 8,
> +	BLK_MQ_F_ALLOC_POLICY_START_BIT = 16,
>   	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
>   
>   	BLK_MQ_S_STOPPED	= 0,
> @@ -705,6 +706,7 @@ int blk_mq_alloc_sq_tag_set(struct blk_mq_tag_set *set,
>   		const struct blk_mq_ops *ops, unsigned int queue_depth,
>   		unsigned int set_flags);
>   void blk_mq_free_tag_set(struct blk_mq_tag_set *set);
> +void blk_mq_update_fair_sharing(struct blk_mq_tag_set *set, bool enable);
>   
>   void blk_mq_free_request(struct request *rq);
>   int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
> 
> .
> 


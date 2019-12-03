Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC071C43215
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 14:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A6C12084B
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 14:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLCOxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 09:53:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:47180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbfLCOxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Dec 2019 09:53:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83A8EB494;
        Tue,  3 Dec 2019 14:53:48 +0000 (UTC)
Subject: Re: [PATCH 03/11] blk-mq: rename blk_mq_update_tag_set_depth()
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-4-hare@suse.de>
 <fbc08f2a-e500-5e29-ccdc-c5a89be446dd@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <1ed59228-ad6b-bccc-ffa8-488ec2ee5801@suse.de>
Date:   Tue, 3 Dec 2019 15:53:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <fbc08f2a-e500-5e29-ccdc-c5a89be446dd@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/19 3:30 PM, John Garry wrote:
> On 02/12/2019 15:39, Hannes Reinecke wrote:
>> The function does not set the depth, but rather transitions from
>> shared to non-shared queues and vice versa.
>> So rename it to blk_mq_update_tag_set_shared() to better reflect
>> its purpose.
> 
> We will probably need to split this patch into two, as we're doing more
> than just renaming.
> 
> The prep patches could be picked up earlier if we're lucky.
> 
> Thanks,
> John
> 
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   block/blk-mq-tag.c | 18 ++++++++++--------
>>   block/blk-mq.c     |  8 ++++----
>>   2 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index d7aa23c82dbf..f5009587e1b5 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -440,24 +440,22 @@ static int bt_alloc(struct sbitmap_queue *bt,
>> unsigned int depth,
>>                          node);
>>   }
>>   -static struct blk_mq_tags *blk_mq_init_bitmap_tags(struct
>> blk_mq_tags *tags,
>> -                           int node, int alloc_policy)
>> +static int blk_mq_init_bitmap_tags(struct blk_mq_tags *tags,
>> +                   int node, int alloc_policy)
>>   {
>>       unsigned int depth = tags->nr_tags - tags->nr_reserved_tags;
>>       bool round_robin = alloc_policy == BLK_TAG_ALLOC_RR;
>>         if (bt_alloc(&tags->bitmap_tags, depth, round_robin, node))
>> -        goto free_tags;
>> +        return -ENOMEM;
>>       if (bt_alloc(&tags->breserved_tags, tags->nr_reserved_tags,
>> round_robin,
>>                node))
>>           goto free_bitmap_tags;
>>   -    return tags;
>> +    return 0;
>>   free_bitmap_tags:
>>       sbitmap_queue_free(&tags->bitmap_tags);
>> -free_tags:
>> -    kfree(tags);
>> -    return NULL;
>> +    return -ENOMEM;
>>   }
>>     struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>> @@ -478,7 +476,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int
>> total_tags,
>>       tags->nr_tags = total_tags;
>>       tags->nr_reserved_tags = reserved_tags;
>>   -    return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
>> +    if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
>> +        kfree(tags);
>> +        tags = NULL;
>> +    }
>> +    return tags;
>>   }
>>     void blk_mq_free_tags(struct blk_mq_tags *tags)
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 6b39cf0efdcd..91950d3e436a 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2581,8 +2581,8 @@ static void queue_set_hctx_shared(struct
>> request_queue *q, bool shared)
>>       }
>>   }
>>   -static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set,
>> -                    bool shared)
>> +static void blk_mq_update_tag_set_shared(struct blk_mq_tag_set *set,
>> +                     bool shared)
>>   {
>>       struct request_queue *q;
>>   @@ -2605,7 +2605,7 @@ static void blk_mq_del_queue_tag_set(struct
>> request_queue *q)
>>           /* just transitioned to unshared */
>>           set->flags &= ~BLK_MQ_F_TAG_QUEUE_SHARED;
>>           /* update existing queue */
>> -        blk_mq_update_tag_set_depth(set, false);
>> +        blk_mq_update_tag_set_shared(set, false);
>>       }
>>       mutex_unlock(&set->tag_list_lock);
>>       INIT_LIST_HEAD(&q->tag_set_list);
>> @@ -2623,7 +2623,7 @@ static void blk_mq_add_queue_tag_set(struct
>> blk_mq_tag_set *set,
>>           !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)) {
>>           set->flags |= BLK_MQ_F_TAG_QUEUE_SHARED;
>>           /* update existing queue */
>> -        blk_mq_update_tag_set_depth(set, true);
>> +        blk_mq_update_tag_set_shared(set, true);
>>       }
>>       if (set->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
>>           queue_set_hctx_shared(q, true);
>>
> 
Hmm. That shouldn't have happened; I'm sure I've had it in two patches
originally. Oh well.

But I'd rather wait for feedback to my shared scheduler tag patch; guess
that'll meet with some raise eyebrows ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

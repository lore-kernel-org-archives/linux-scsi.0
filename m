Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4193BC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F602222E
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 07:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgLBHQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 02:16:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:38004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387591AbgLBHQL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 02:16:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ADFD2ABD2;
        Wed,  2 Dec 2020 07:15:29 +0000 (UTC)
Subject: Re: [PATCH v4 8/9] block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
References: <20201130024615.29171-1-bvanassche@acm.org>
 <20201130024615.29171-9-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <497a5191-3c95-83ea-953b-8709cee0e23f@suse.de>
Date:   Wed, 2 Dec 2020 08:15:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201130024615.29171-9-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/20 3:46 AM, Bart Van Assche wrote:
> Remove flag RQF_PREEMPT and BLK_MQ_REQ_PREEMPT since these are no longer
> used by any kernel code.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-core.c       | 7 +++----
>   block/blk-mq-debugfs.c | 1 -
>   block/blk-mq.c         | 2 --
>   include/linux/blk-mq.h | 2 --
>   include/linux/blkdev.h | 6 +-----
>   5 files changed, 4 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

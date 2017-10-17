From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 06/10] block: Introduce BLK_MQ_REQ_PREEMPT
Date: Tue, 17 Oct 2017 08:26:38 +0200
Message-ID: <58fa4acf-7c6b-b71a-a898-b1457052ad6a@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-7-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756951AbdJQG0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 02:26:40 -0400
In-Reply-To: <20171016232905.5047-7-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 10/17/2017 01:29 AM, Bart Van Assche wrote:
> Set RQF_PREEMPT if BLK_MQ_REQ_PREEMPT is passed to
> blk_get_request_flags().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  block/blk-core.c       | 4 +++-
>  block/blk-mq.c         | 2 ++
>  include/linux/blk-mq.h | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

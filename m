From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 04/10] block: Make q_usage_counter also track legacy
 requests
Date: Tue, 17 Oct 2017 08:25:12 +0200
Message-ID: <f37f1b4b-6dff-6b36-d012-241bdabc1228@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-5-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 01:28 AM, Bart Van Assche wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> This patch makes it possible to pause request allocation for
> the legacy block layer by calling blk_mq_freeze_queue() and
> blk_mq_unfreeze_queue().
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> [ bvanassche: Combined two patches into one, edited a comment and made sure
>   REQ_NOWAIT is handled properly in blk_old_get_request() ]
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  block/blk-core.c | 12 ++++++++++++
>  block/blk-mq.c   | 10 ++--------
>  2 files changed, 14 insertions(+), 8 deletions(-)
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

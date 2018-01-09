From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] blk-mq: Rename request_queue.mq_freeze_wq into mq_wq
Date: Tue, 9 Jan 2018 07:34:49 +0100
Message-ID: <e05d056e-5f36-4a79-cf90-52b029551640@suse.de>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
 <20180108185011.30018-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46839 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbeAIGew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 01:34:52 -0500
In-Reply-To: <20180108185011.30018-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Ming Lei <ming.lei@redhat.com>

On 01/08/2018 07:50 PM, Bart Van Assche wrote:
> Rename a waitqueue in struct request_queue since the next patch will
> add code that uses this waitqueue outside the request queue freezing
> implementation.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-core.c       | 10 +++++-----
>  block/blk-mq.c         | 10 +++++-----
>  include/linux/blkdev.h |  2 +-
>  3 files changed, 11 insertions(+), 11 deletions(-)
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

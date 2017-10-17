From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 07/10] ide, scsi: Tell the block layer at request
 allocation time about preempt requests
Date: Tue, 17 Oct 2017 08:27:07 +0200
Message-ID: <08f79033-9eb5-71a8-bef8-44480e0ce2f0@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-8-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57867 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756944AbdJQG1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 02:27:09 -0400
In-Reply-To: <20171016232905.5047-8-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 10/17/2017 01:29 AM, Bart Van Assche wrote:
> Convert blk_get_request(q, op, __GFP_RECLAIM) into
> blk_get_request_flags(q, op, BLK_MQ_PREEMPT). This patch does not
> change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> Acked-by: David S. Miller <davem@davemloft.net> [ for IDE ]
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/ide/ide-pm.c    | 4 ++--
>  drivers/scsi/scsi_lib.c | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
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

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 4/7] block: Define zoned block device operations
Date: Fri, 30 Sep 2016 09:20:20 +0200
Message-ID: <ac02bb6f-50e7-ce56-8f61-3f7da82e173d@suse.de>
References: <1475208699-27310-1-git-send-email-damien.lemoal@hgst.com>
 <1475208699-27310-5-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475208699-27310-5-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On 09/30/2016 06:11 AM, Damien Le Moal wrote:
> From: Shaun Tancheff <shaun.tancheff@seagate.com>
>
> Define REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET for handling zones of
> host-managed and host-aware zoned block devices. With with these two
> new operations, the total number of operations defined reaches 8 and
> still fits with the 3 bits definition of REQ_OP_BITS.
>
> Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

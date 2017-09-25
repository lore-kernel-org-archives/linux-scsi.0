From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V5 06/14] block: Add zoned block device information to
 request queue
Date: Mon, 25 Sep 2017 18:05:50 +0800
Message-ID: <20170925100549.GA13400@ming.t460p>
References: <20170925061454.5533-1-damien.lemoal@wdc.com>
 <20170925061454.5533-7-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932627AbdIYKGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 06:06:00 -0400
Content-Disposition: inline
In-Reply-To: <20170925061454.5533-7-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On Mon, Sep 25, 2017 at 03:14:46PM +0900, Damien Le Moal wrote:
> Components relying only on the requeuest_queue structure for accessing
> block devices (e.g. I/O schedulers) have a limited knowledged of the
> device characteristics. In particular, the device capacity cannot be
> easily discovered, which for a zoned block device also result in the
> inability to easily know the number of zones of the device (the zone
> size is indicated by the chunk_sectors field of the queue limits).
> 
> Introduce the nr_zones field to the request_queue sturcture to simplify
> access to this information. Also, add the bitmap seq_zone_bitmap which
> indicates which zones of the device are sequential zones (write
> preferred or write required). These two fields are initialized by the
> low level block device driver (sd.c for ZBC/ZAC disks). They are not
> initialized by stacking drivers (device mappers) handling zoned block
> devices (e.g. dm-linear).
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

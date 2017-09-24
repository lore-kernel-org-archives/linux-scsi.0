From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 11/16] block: mq-deadline: Introduce zones_wlock
        attribute
Date: Sun, 24 Sep 2017 17:19:32 +0200
Message-ID: <20170924151932.GC16608@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com> <20170924070247.25560-12-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-12-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 24, 2017 at 04:02:42PM +0900, Damien Le Moal wrote:
> Zone write locking is mandatory for host managed zoned block devices so
> that sequential write order can be maintained. This is however optional
> for host aware devices as the device firmware can handle random writes.
> 
> The default initialization always enable zones write locking for any
> zoned block device. Introduce the zones_wlock sysfs attribute to allow
> users to change this default setting for host aware disks. Changes to
> zones write locking state are not allowed for host managed disks (zones
> write locking is always enabled) and for regular disks (zones write
> locking is always disabled).

Is it really worth the effort?  Until someone who really ares about
HA drives and shows a benefit for a workload that matters I'd just
leave to code off for HA.

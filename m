From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 11/12] scsi: sd: Introduce scsi_disk_from_queue()
Date: Sun, 10 Sep 2017 13:16:56 +0800
Message-ID: <20170910051655.GC11628@ming.t460p>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-12-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907161640.30465-12-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 08, 2017 at 01:16:39AM +0900, Damien Le Moal wrote:
> Using scsi_device_from_queue(), return the scsi_disk structure
> associated with a request queue if the device is a disk.
> Export this function to make it available to modules.
> 

This approach may be a little over-kill, actually gendisk is the
parent of request queue in kobject tree(see blk_register_queue()),
that might be an easy way to retrieve disk attached to the queue.

-- 
Ming

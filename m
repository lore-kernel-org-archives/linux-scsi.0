From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Wed, 13 Sep 2017 22:17:13 +0200
Message-ID: <20170913201713.GA24926@lst.de>
References: <20170907161640.30465-1-damien.lemoal@wdc.com> <20170908082040.GA25719@lst.de> <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com> <20170911122411.GA22255@lst.de> <36d21ce8-543a-39ad-c729-30f9dbd383d0@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57606 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbdIMURP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 16:17:15 -0400
Content-Disposition: inline
In-Reply-To: <36d21ce8-543a-39ad-c729-30f9dbd383d0@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>

On Tue, Sep 12, 2017 at 05:38:05PM +0900, Damien Le Moal wrote:
> struct blk_zoned {
> 	unsigned int nr_zones;
> 	unsigned long *seq_zones;
> };
> 
> struct request_queue {
> 	...
> #ifdef CONFIG_BLK_DEV_ZONED
> 	struct blk_zoned zoned;
> #endif
> 	...

Do we even need a new structure for it?  I'd just hang it off
the gendisk directly.

Except for that the idea looks fine to me.

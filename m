From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Fri, 15 Sep 2017 19:51:18 +0200
Message-ID: <20170915175117.GG8578@lst.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com> <20170915100645.17999-7-damien.lemoal@wdc.com> <1505487062.2852.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505487062.2852.12.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2017 at 02:51:03PM +0000, Bart Van Assche wrote:
> On Fri, 2017-09-15 at 19:06 +0900, Damien Le Moal wrote:
> > Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
> > assignments and move the calculation of sdkp->zone_shift together
> > with the assignment of the verified zone_blocks value in
> > sd_zbc_check_zone_size().
> 
> Both functions are called from inside block_device_operations.revalidate_disk.
> Isn't that too late to set use_1[06]_for_rw? Shouldn't both be set just after
> the slave_alloc callback has been called?

Hmm.  sd_read_capacity already is called from the same path and seems
to work..

> 
> Thanks,
> 
> Bart.---end quoted text---

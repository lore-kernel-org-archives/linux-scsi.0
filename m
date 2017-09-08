From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2 09/12] scsi: sd_zbc: Limit zone write locking to
        sequential zones
Date: Fri, 8 Sep 2017 11:48:09 +0200
Message-ID: <20170908094809.GA27141@lst.de>
References: <20170907161640.30465-1-damien.lemoal@wdc.com> <20170907161640.30465-10-damien.lemoal@wdc.com> <20170908083925.kw4ungsvxxsgtb4i@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170908083925.kw4ungsvxxsgtb4i@linux-x5ow.site>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 08, 2017 at 10:39:25AM +0200, Johannes Thumshirn wrote:
> It's a shame we have all this overflow checking kcalloc() and
> kmalloc_array() functions but none of them is taking NUMA nodes into
> account.

Something that could be trivially fixed..

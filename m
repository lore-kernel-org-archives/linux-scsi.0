From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
Date: Wed, 24 Sep 2014 10:33:20 -0400
Message-ID: <20140924143320.GG16555@htj.dyndns.org>
References: <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de>
 <20140923061152.GI11740@mtj.dyndns.org>
 <5421968B.7080309@kernel.dk>
 <20140923192432.GA24441@mtj.dyndns.org>
 <20140924082348.GB8894@lst.de>
 <5422D589.5070009@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5422D589.5070009@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 24, 2014 at 08:30:33AM -0600, Jens Axboe wrote:
> On 09/24/2014 02:23 AM, Christoph Hellwig wrote:
> > Thanks, this fixes the boot stall for me.
> > 
> > Tested-by: Christoph Hellwig <hch@lst.de>
> 
> Sweet, I'll shove this off today, so we are done for 3.17 release.

Cool, once it hits the block branch, I'll pull it into percpu/for-3.18
and apply the patches for proper fix on top.

Thanks.

-- 
tejun

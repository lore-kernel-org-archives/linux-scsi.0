From: Tejun Heo <tj@kernel.org>
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Date: Tue, 23 Sep 2014 02:01:41 -0400
Message-ID: <20140923060141.GF11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140923055924.GA10295@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2014 at 07:59:24AM +0200, Christoph Hellwig wrote:
> "[PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()"
> 
> looks way to big for 3.17, and the regression was introduced in the 3.17
> merge window.  I'm not sure what was broken before, but it defintively
> survived a lot of testing.

Do we even care about fixing it for 3.17?  scsi-mq isn't enabled by
default even for 3.18.  The open-coded percpu ref thing was subtly
broken there.  It'd be difficult to trigger but I'm fairly sure it'd
crap out in the wild once in a blue moon.

Thanks.

-- 
tejun

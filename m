From: Tejun Heo <tj@kernel.org>
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Date: Tue, 23 Sep 2014 01:57:24 -0400
Message-ID: <20140923055724.GE11740@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140923055648.GD11740@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2014 at 01:56:48AM -0400, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 07:55:54AM +0200, Christoph Hellwig wrote:
> > Jens,
> > 
> > can we simply get these commits reverted from now if there's no better
> > fix?  I'd hate to have this boot stall in the first kernel with blk-mq
> > support for scsi.
> 
> Patches going out right now.

And the original implementation was broken, so...

-- 
tejun

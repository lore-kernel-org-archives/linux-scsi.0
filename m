From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 11 Jan 2017 17:01:22 -0500
Message-ID: <20170111220122.GA19051@redhat.com>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-15-git-send-email-hch@lst.de>
 <20170111084218.GB6286@linux-x5ow.site>
 <20170111084512.GA6937@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111084512.GA6937@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11 2017 at  3:45am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Jan 11, 2017 at 09:42:44AM +0100, Johannes Thumshirn wrote:
> > On Tue, Jan 10, 2017 at 04:06:19PM +0100, Christoph Hellwig wrote:
> > > Simply the boilerplate code needed for bsg nodes a bit.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > that reminds me of posting my SAS bsg-lib patch...
> 
> Yes.  Having SAS use bsg-lib, and bsg-lib switched away from abusing
> struct request_queue would make this series a lot cleaner.
> 
> So maybe we should get that into the scsi tree for 4.10 together
> with the prep patches in this series as a priority and defer the actual
> struct request changes once again.  That should also give us some more
> time to sort out the dm-mpath story..

I'm not aware of the story you're referring to.  I'm missing the actual
challenge you're facing.

But I've seen you reference the need to stop multipath from allocating
its own requests.  Are you referring to old request_fn request-based
multipath's clone_old_rq:alloc_old_clone_request?

Or how blk-mq request-based multipath gets a request from the blk-mq tag
space (via blk_mq_alloc_request)?

Or both?  How is that holding you back?

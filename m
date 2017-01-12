From: Christoph Hellwig <hch@lst.de>
Subject: Re: RFC: split scsi passthrough fields out of struct request
Date: Thu, 12 Jan 2017 08:59:55 +0100
Message-ID: <20170112075952.GC7567@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <20170111224142.GA19238@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111224142.GA19238@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 05:41:42PM -0500, Mike Snitzer wrote:
> I removed blk-mq on request_fn paths support because it was one of the
> permutations that I felt least useful/stable (see commit c5248f79f3 "dm:
> remove support for stacking dm-mq on .request_fn device(s)")
> 
> As for all of the different IO paths.  I've always liked the idea of
> blk-mq ruling the world.  With Jens' blk-mq IO scheduling advances maybe
> we're closer!

That removed blk-mq on top of request_fn code would do the right thing
for this series if it entirely replaced the old request_fn code in dm-mpath.
(as would the new bio code for that matter)

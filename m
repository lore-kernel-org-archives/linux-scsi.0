From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] blk-mq: support for shared tags
Date: Wed, 2 Apr 2014 09:46:32 +0200
Message-ID: <20140402074632.GA11359@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <533B56D5.5070803@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 01, 2014 at 05:16:21PM -0700, Matias Bjorling wrote:
> Hi Christoph,
> 
> Can you rebase it on top of 3.14. I have trouble applying it for testing.

Hi Martin,

the series is based on top of Jens' for-next branch.  I've also pushed out a
git tree to the blk-mq-share-tags.2 branch of

	git://git.infradead.org/users/hch/scsi.git

to make testing and reviewing easier.

> For nvme, there's need for two separate types of queues. The admin queue
> (before initializing blk-mq) and the actual hardware queues.
> 
> Should we allow the driver to get/put tags before initializing blk-mq?
> Or let drivers implement their own framework?

What do you mean with initializing blk-mq?  We need to allocate data
structures for sure, and I don't see much else in terms of initialization
in blk-mq.

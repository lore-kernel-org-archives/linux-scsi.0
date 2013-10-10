From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Date: Thu, 10 Oct 2013 21:32:41 +0200
Message-ID: <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
 <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
 <20131010191714.GA3098@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131010191714.GA3098@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 10, 2013 at 09:17:14PM +0200, Christoph Hellwig wrote:
> > What is the criteria for patches to include in your tree? I would suggest
> > to consider this one https://lkml.org/lkml/2013/8/9/90 if it fits.
> 
> For this one you probably want to send a patch to Jens to move blk-mq-tag.h
> to include/linux first instead of doing the relative include hack.

I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
generic to me.

> Also the  blk_mq_*tag* routines you use aren't exported, so a modular build of
> the driver with that patch applied will fail.

Yep, makes sense. Thanks for pointing out.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

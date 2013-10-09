From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Date: Wed, 9 Oct 2013 21:46:58 +0200
Message-ID: <20131009194658.GA3066@dhcp-26-207.brq.redhat.com>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 09, 2013 at 12:12:51PM -0700, Nicholas A. Bellinger wrote:
> Just a heads up that the scsi-mq alpha branch has been updated to Jen's
> latest linux-block/new-queue containing hch's recent blk-mq
> improvements, along with Alexander's patch for the is_flush_fua +
> queue_depth=1 bug.


Oh, I have not expected it could be picked up. In fact I agree it needs
to be updated with what you spotted:

"Also, these extra increments should probably happen only when the passed
queue_depth == 1 && reserved_tags == 0."

What is the criteria for patches to include in your tree? I would suggest
to consider this one https://lkml.org/lkml/2013/8/9/90 if it fits.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

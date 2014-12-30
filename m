From: Christoph Hellwig <hch@infradead.org>
Subject: [ANNOUNCE] scsi patch queue tree updated
Date: Tue, 30 Dec 2014 05:02:30 -0800
Message-ID: <20141230130230.GA28717@infradead.org>
References: <20140708134003.GA7790@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140708134003.GA7790@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It turnd out while the scsi-queue tree in general worked very well
the split into core and drivers branches was rather cumbersome.

For the 3.19 merge window updates and the 3.20 window I've switched
to a single branch instead:

   git://git.infradead.org/users/hch/scsi-queue.git scsi-for-3.19
   git://git.infradead.org/users/hch/scsi-queue.git scsi-for-3.20

So far there 3.20 tree is still rather small, but there are a couple
of series that need a resend or review and should go in.

The rules from the original scsi-queue tree have worked well, so they
still apply with a minor change.  These rules are:

 - the patch needs at least two positive reviews (non-author signoff,
   reviewed-by or acked-by tags).   In practice this means it had at
   least one and I added another one.
   As an exception I also take trivial and important fixes if they
   only have a Tested-by: instead of a second review.
 - the patch has no negative review on the mailing list
 - the patch applies cleanly
 - the patch compiles (drivers for architectures I can't test excluded)
 - for core the core branch: the patch survives a full xfstests run

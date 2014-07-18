From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Fri, 18 Jul 2014 03:02:30 -0700
Message-ID: <20140718100230.GA23521@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I've pushed out new version of the for-3.17 core and drivers trees:

  git://git.infradead.org/users/hch/scsi-queue.git core-for-3.17
  git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17

In the core tree the biggest update is the merge of the I/O path
cleanups, in addition various individual patches were merged, and
the a few fixes for the 64-bit LUN series were squashed into the
patches.

The drivers side gained various updates, but there's still lots of
driver work on the list that needs more reviews.

I did a rebase to Linus' latest tree to pick up the fix for the aio
regression to help people doing IOPS testing.

Note that I've also pushed out a core-for-3.16 tree with James' flush
fix in case James wants to push this for 3.16 still; but this late
in the release cycles it might be better to wait for 3.17 for this as
well.

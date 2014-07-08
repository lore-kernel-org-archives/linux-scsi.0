From: Christoph Hellwig <hch@infradead.org>
Subject: [ANNOUNCE] scsi patch queue tree updated
Date: Tue, 8 Jul 2014 06:40:03 -0700
Message-ID: <20140708134003.GA7790@infradead.org>
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

In the core tree the biggest news is the old target infrastructure
removal, in addition a few warnings due to 64-bit LUNs have been fixed,
and the tree has been rebased to 3.16-rc4 to pick up all updates that
went into the Linux 3.16 release candidates.

The drivers-for-3.17 tree is new, and I should have picked up all
properly reviewed patches.

Most notably missing from the drivers tree are the mpt2sas and mpt3sas
series and the scsi_debug update which need a review, and the megaraid
and pm8001 uptdates which need a resend.  Missing from the core tree
is the scsi-mq work that still needs a proper review.

Also notably absent is the flush error handling fix, which still needs a
signoff from James and a proper review.  As far as I'm concerned that
fix should still go into 3.16.

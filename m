From: Christoph Hellwig <hch@infradead.org>
Subject: status of block-integrity
Date: Sun, 22 Dec 2013 11:21:29 -0800
Message-ID: <20131222192128.GA28532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We have the block integrity code to support DIF/DIX in the the tree for
about 5 and a half years, and we still don't have a single consumer of
it.  By normal kernel rules it should never have been merged, or at
least the bitrot long removed.

Given that we'll have a lot of work to do in this area with block
multiqueue I think it's time to either kill it off for good or make sure
we can actually use and test it.

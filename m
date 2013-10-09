From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: scsi-mq updated to latest linux-block/new-queue
Date: Wed, 09 Oct 2013 12:12:51 -0700
Message-ID: <1381345971.19256.461.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Alexander Gordeev <agordeev@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

Just a heads up that the scsi-mq alpha branch has been updated to Jen's
latest linux-block/new-queue containing hch's recent blk-mq
improvements, along with Alexander's patch for the is_flush_fua +
queue_depth=1 bug.

The branch @ v3.12-rc3 is available here:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq

The main changes include dropping all of the blk_mq_alloc_request() +
blk_mq_free_request() changes that are now unnecessary with hch's
improvements in place, along with other miscellaneous cleanups.

--nab

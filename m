From: Christoph Hellwig <hch@lst.de>
Subject: two more fixes for block/for-linus
Date: Mon, 22 Sep 2014 15:59:29 +0200
Message-ID: <1411394371-16254-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix two regressions with the timer/blk_mq_start_request changes found
when using scsi-mq on an ATA device.

Note that given how late we are in the cycle I wonder if we really should
push the changes in block/for-linus to Linus in this cycle.  The race
part of the timer fixes is extremly narrow, and the reserved request
part of it requires an out of tree driver update to trigger it, so it
doesn't sound super criticial.

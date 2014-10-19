From: Christoph Hellwig <hch@lst.de>
Subject: fix blk-mq for SPI hosts
Date: Sun, 19 Oct 2014 17:13:56 +0200
Message-ID: <1413731638-28305-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix the assumption that we can treat all blk-mq requests as tagged.  For
traditional SCSI that's wrong, as being tagged has a very explicit meaning
on the wire.

This is a little bit different from the version Meelis tested earlier, but
the concept is the same.  I didn't want to add a Tested-by tag as it's
different enough, though.

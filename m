From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/2] Show commands stuck in a timeout handler in debugfs
Date: Mon,  4 Dec 2017 16:38:07 -0800
Message-ID: <20171205003809.1705-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

While debugging an issue with the SCSI error handler I noticed that commands
that got stuck in that error handler are not shown in debugfs. That is very
annoying for anyone who relies on the information in debugfs for root-causing
such an issue. Hence this patch series that makes sure that commands that got
stuck in a block driver timeout handler are also shown in debugfs. Please
consider these patches for kernel v4.16.

Thanks,

Bart.

Bart Van Assche (2):
  scsi-mq: Only show the CDB if available
  blk-mq-debugfs: Also show requests that have not yet been started

 block/blk-mq-debugfs.c      |  2 +-
 drivers/scsi/scsi_debugfs.c | 47 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 6 deletions(-)

-- 
2.15.0

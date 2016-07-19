From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] Support for zoned block devices
Date: Tue, 19 Jul 2016 15:20:33 +0200
Message-ID: <1468934439-93579-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbcGSNUn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>

Hi Jens,

this patchset adds support for zoned block devices to the block layer.
Support for it is selected with the new 'BLK_DEV_ZONED' config option.

Patch has been made over Tejuns 'libata/for-4.8' repository.

As usual, comments and reviews are welcome.

Hannes Reinecke (6):
  blk-sysfs: Add 'chunk_sectors' to sysfs attributes
  block: update chunk_sectors in blk_stack_limits()
  block: Implement support for zoned block devices
  block: Add 'zoned' sysfs queue attribute
  block: Introduce BLKPREP_DONE
  block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value

 block/Kconfig           |  9 +++++++
 block/Makefile          |  1 +
 block/blk-core.c        | 11 +++++++-
 block/blk-mq.c          |  1 +
 block/blk-settings.c    |  4 +++
 block/blk-sysfs.c       | 57 ++++++++++++++++++++++++++++++++++++++++
 block/blk-zoned.c       | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c |  4 +++
 include/linux/blk-mq.h  |  1 +
 include/linux/blkdev.h  | 48 +++++++++++++++++++++++++++++++++
 10 files changed, 205 insertions(+), 1 deletion(-)
 create mode 100644 block/blk-zoned.c

-- 
1.8.5.6


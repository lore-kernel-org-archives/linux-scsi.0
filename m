From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] dm-zoned target for ZBC devices
Date: Tue, 19 Jul 2016 16:02:55 +0200
Message-ID: <1468936978-9124-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcGSODF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 10:03:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>

Hi all,

this patchset implements a 'dm-zoned' device-mapper target to handle
ZBC host-managed (and host-aware) devices as 'normal' disks.

Patch has been made over Tejuns 'libata/for-4.8' repository.
It relies on the patchsets "Support for zoned block devices" and
"Add support for ZBC host-managed devices" posted earlier.

As usual, comments and reviews are welcome.

Damien Le Moal (1):
  dm-zoned: New device mapper target for zoned block devices

Hannes Reinecke (2):
  block: add flag for single-threaded submission
  sd: enable single-threaded I/O submission for zoned devices

 Documentation/device-mapper/dm-zoned.txt |  147 +++
 block/blk-core.c                         |    2 +
 drivers/md/Kconfig                       |   14 +
 drivers/md/Makefile                      |    2 +
 drivers/md/dm-zoned-io.c                 | 1186 ++++++++++++++++++
 drivers/md/dm-zoned-meta.c               | 1950 ++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c            |  770 ++++++++++++
 drivers/md/dm-zoned.h                    |  687 +++++++++++
 drivers/scsi/sd.c                        |    1 +
 include/linux/blkdev.h                   |    2 +
 10 files changed, 4761 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-zoned.txt
 create mode 100644 drivers/md/dm-zoned-io.c
 create mode 100644 drivers/md/dm-zoned-meta.c
 create mode 100644 drivers/md/dm-zoned-reclaim.c
 create mode 100644 drivers/md/dm-zoned.h

-- 
1.8.5.6


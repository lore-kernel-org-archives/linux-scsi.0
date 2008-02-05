From: Tejun Heo <htejun@gmail.com>
Subject: [PATCHSET #upstream] block/libata: update and use block layer padding and draining
Date: Tue,  5 Feb 2008 16:53:00 +0900
Message-ID: <12021979851743-git-send-email-htejun@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Jens.Axboe@oracle.com, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org


This patchset updates block layer padding and draining support and
make libata use it.  It's based on James Bottomley's initial work and,
of the five, the last two patches are from James with some
modifications.

Please read the following thread for more info.

  http://thread.gmane.org/gmane.linux.scsi/37185

This patchset is on top of

  upstream (a6af42fc9a12165136d82206ad52f18c5955ce87)
+ kill-n_iter-and-fix-fsl patch [1]

 block/blk-core.c              |    2
 block/blk-map.c               |   19 +++++
 block/blk-merge.c             |    3
 block/blk-settings.c          |    7 +-
 block/bsg.c                   |    8 +-
 block/scsi_ioctl.c            |    3
 drivers/ata/ahci.c            |    5 -
 drivers/ata/libata-core.c     |  145 ++----------------------------------------
 drivers/ata/libata-scsi.c     |   54 ++++++++++-----
 drivers/ata/pata_icside.c     |    8 --
 drivers/ata/sata_fsl.c        |   13 ---
 drivers/ata/sata_mv.c         |    6 -
 drivers/ata/sata_sil24.c      |    5 -
 drivers/scsi/ipr.c            |    4 -
 drivers/scsi/libsas/sas_ata.c |    4 -
 drivers/scsi/scsi_lib.c       |    8 +-
 include/linux/blkdev.h        |    8 +-
 include/linux/libata.h        |   28 --------
 18 files changed, 95 insertions(+), 235 deletions(-)

Thanks.

--
tejun

[1] http://article.gmane.org/gmane.linux.ide/28038

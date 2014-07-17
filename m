From: Robert Elliott <elliott@hp.com>
Subject: [PATCH 0/3] blk-mq: blk_mq_init_rq_map error handling
Date: Thu, 17 Jul 2014 14:38:58 -0500
Message-ID: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com, nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com, snitzer@redhat.com, JBottomley@parallels.com, relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com, praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com, scameron@beardog.cce.hp.com, tom.leiming@gmail.com, elliott@hp.com, sbradshaw@micron.com, hch@lst.de, m@bjorling.me
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The following series cleans up blk_mq_init_rq_map failures
properly.

---

Robert Elliott (3):
      blk-mq: cleanup after blk_mq_init_rq_map failures
      blk-mq: pass along blk_mq_alloc_tag_set return values
      mpt3sas,mpt2sas: fix scsi_add_host error handling problems in _scsih_probe


 block/blk-mq.c                       |    3 +++
 drivers/block/mtip32xx/mtip32xx.c    |    1 -
 drivers/block/null_blk.c             |   29 +++++++++++++++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    9 ++++++---
 5 files changed, 36 insertions(+), 14 deletions(-)

-- 
Rob Elliott, HP Server Storage

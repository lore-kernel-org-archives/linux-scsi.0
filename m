From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH v3 0/4] mpt3sas driver Enhancements and defect fixes:
Date: Mon, 23 Jan 2017 15:26:06 +0530
Message-ID: <1485165370-43401-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Here is the change list:
Posting 4 patches for mpt3sas driver enhancement and defect fixes.
  * Handle cable event for notifying degraded speed.
  * Performance improvement for Crusader.
  * Fix Firmware fault state 0x2100 during heavy 4K RR
    FIO stress test.
  * Updated driver version to 15.100.00.00

Chaitra P B (4):
  mpt3sas: Added print to notify cable running at a degraded
    speed.
  mpt3sas: Fix for Crusader to achieve product targets with SAS
    devices.
  mpt3sas: Fix Firmware fault state 0x2100 during heavy 4K RR       
    FIO stress test.
  mpt3sas: Updating driver version to v15.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |    2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   20 ++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    7 ++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    4 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   56 +++++++++++++++++++++++++++-------
 5 files changed, 74 insertions(+), 15 deletions(-)

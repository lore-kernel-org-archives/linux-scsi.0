From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 00/10] [SCSI] mpt3sas: Phase15 driver enhancements and fixes
Date: Tue, 10 Oct 2017 18:41:13 +0530
Message-ID: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Phase15 driver enhancements and fixes.

Sreekanth Reddy (10):
  mpt3sas: Processing of Cable Exception events
  mpt3sas: Fixed memory leaks in driver
  mpt3sas: Reduce memory footprints in kdump kernel
  mpt3sas: Fix removal and addition of vSES device during host reset
  mpt3sas: Fix IO error occurs on pulling out a drive from RAID1 volume
    created on two SATA drive
  mpt3sas: Updated MPI headers to v2.00.48
  mpt3sas: Display chassis slot information of the drive
  mpt3sas: Fix possibility of using invalid Enclosure Handles for SAS
    device after host reset
  mpt3sas: Adding support for SAS3616 HBA device
  mpt3sas: Bump mpt3sas driver version to v16.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h      |  43 ++-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 564 +++++++++++++++++++++++++++++++++--
 drivers/scsi/mpt3sas/mpi/mpi2_init.h |  11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  | 282 +++++++++++++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h  | 112 +++++++
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h |  14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  19 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 383 ++++++++++++++----------
 9 files changed, 1241 insertions(+), 197 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h

-- 
2.4.3

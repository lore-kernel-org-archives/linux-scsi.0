From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 0/6] mpt3sas: driver update to Phase12.
Date: Fri,  6 May 2016 14:29:25 +0530
Message-ID: <1462525171-6877-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-kernel@vger.kernel.org, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Here is the change list:
* Updated MPI version and MPI header files.
* Handle active cable exception event for Intruder/Cutlass HBAs.
* Use scsi_prot_ref_tag()API to fill reference tag field in the CDB.
* Updated mpt3sas driver version to Ph12 13.100.00.00
* Set maximum transfer length per IO on RAID volumes to 4MB.
* Use "synchronize_irq()"API to handle Asynchronous TM's completion.

Chaitra P B (6):
  mpt3sas: Update MPI header to 2.00.42
  mpt3sas: Handle active cable exception event
  mpt3sas: Fix initial Reference tag field for 4K PI drives.
  mpt3sas: Updating mpt3sas driver version to 13.100.00.00
  mpt3sas: Set maximum transfer length per IO to 4MB for VDs
  mpt3sas: Used "synchronize_irq()"API to synchronize timed-out IO
    & TMs

 drivers/scsi/mpt3sas/mpi/mpi2.h      |  7 +++++--
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 18 +++++++++++-----
 drivers/scsi/mpt3sas/mpi/mpi2_init.h | 15 +++++++++++---
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  | 40 +++++++++++++++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 20 ++++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  9 +++++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 27 ++++++++++++++++++++++--
 7 files changed, 108 insertions(+), 28 deletions(-)

-- 
1.8.3.1

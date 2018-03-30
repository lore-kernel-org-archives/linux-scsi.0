From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 00/15] mpt3sas: Enhancements and Defect fixes.
Date: Fri, 30 Mar 2018 15:07:09 +0530
Message-ID: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Chaitra P B (15):
  mpt3sas: Fixed warnings.
  mpt3sas: Pre-allocate RDPQ Array at driver boot time.
  mpt3sas: Add sanity checks for scsi tracker before accessing it.
  mpt3sas: Lockless access for chain buffers.
  mpt3sas: Optimize I/O memory consumption in driver.
  mpt3sas: Enhanced handling of Sense Buffer.
  mpt3sas: Added support for SAS Device Discovery Error Event.
  mpt3sas: Increase event log buffer to support 24 port HBA's.
  mpt3sas: Allow processing of events during driver unload.
  mpt3sas: Cache enclosure pages during enclosure add.
  mpt3sas: Report Firmware Package Version from HBA Driver.
  mpt3sas: Update MPI Headers
  mpt3sas: For NVME device, issue a protocol level reset instead of
    hot reset and use TM timeout value exposed in PCIe Device Page  2.
  mpt3sas: fix possible memory leak.
  mpt3sas: Update driver version "25.100.00.00"

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   9 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  30 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h     |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |   7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 484 ++++++++++++++++++++++-------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  62 +++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  38 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 503 +++++++++++++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |   3 +-
 10 files changed, 840 insertions(+), 300 deletions(-)

-- 
1.8.3.1

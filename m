From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 00/22] mpt2sas, mpt3sas: SAS2 Phase 19,20 and SAS3 Phase 4,5 patches
Date: Thu, 20 Nov 2014 12:35:33 +0530
Message-ID: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Please consider this Patch set for next kernel release.

Highlights of this patch set:
- 96 MSIX vector support for SAS3 HBA's,
- Log Temperature threshold exceeds message for any temperature sensor,
- Updating the copy right information,
- Provide physical location of target drives by printing Enclosure level,
  Enclosure address, Slot number etc,
- Displaying OEM's HBA branding String,
- MPI file's update,
- Some driver fixes.

Sreekanth Reddy (22):
  [SCSI] mpt2sas: MPI2 Rev AA (2.00.19) specifications
  [SCSI] mpt2sas, mpt3sas: Added support to log message when Temperature
    Threshold exceeds for any Sensor
  mpt2sas, mpt3sas: Fail the host reset initiated due to discovery
    related I/O timeouts at driver load time
  [SCSI] mpt2sas: Bump driver version to 19.100.00.00
  [SCSI] mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header
    files
  [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the
    module parameter max_sgl_entries
  [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for
    log_info value 0x0x32010081
  [SCSI] mpt2sas, mpt3sas: Update Attribution Language to Avago
  [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each
    MSIX vector enabled by the HBA
  [SCSI] mpt2sas: Bump driver version to 20.100.00.00
  [SCSI] mpt3sas: Added Combined Reply Queue feature to extend up-to 96
    MSIX vector support
  mpt3sas: Get IOC_FACTS information using handshake protocol only after
    HBA card gets into READY or Operational state.
  [SCSI] mpt3sas: Added module parameter 'unblock_io' to unblock IO's
    during disk addition
  [SCSI] mpt2sas, mpt3sas: Remove redundancy code while freeing the
    controller resources.
  [SCSI] mpt3sas: MPI 2.5 Rev I (2.5.4) specifications.
  [SCSI] mpt3sas: Provides the physical location of sas drives
  [SCSI] mpt3sas: Bump mpt3sas Driver version to v5.100.00.00
  [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
  [SCSI] mpt3sas: MPI 2.5 Rev J (2.5.5) specification and 2.00.34 header
    files
  [SCSI] mpt3sas: Add branding string support for OEM's HBA
  mpt3sas: Add branding string support for OEM custom HBA
  [SCSI] mpt3sas: Bump mpt3sas driver version to v6.100.00.00

 drivers/scsi/mpt2sas/mpi/mpi2.h             |   7 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |  51 ++++-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |   4 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         |  79 +++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h         |  15 +-
 drivers/scsi/mpt2sas/mpt2sas_config.c       |  39 +++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |   3 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          |   3 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        |   3 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |  47 +++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |   3 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   7 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  39 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |   4 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 282 ++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  51 ++++-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |  39 +++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 343 ++++++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  17 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |   3 +-
 26 files changed, 913 insertions(+), 148 deletions(-)

-- 
2.0.2

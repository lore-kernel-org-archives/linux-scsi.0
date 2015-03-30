From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 00/20] mpt3sas: driver update
Date: Mon, 30 Mar 2015 19:25:03 +0530
Message-ID: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

This patch set contains all the features and defect fixes from Phase4 to Phase8.

Please review this patch set and consider these patches for next kernel release.

Next time onwards we will make sure to post individual patches as and when we develop a feature & done basic testing instead of posting large set of patches
at once.

Regards,
Sreekanth

Sreekanth Reddy (20):
  [SCSI] mpt3sas: Added Combined Reply Queue feature to extend up-to 96
    MSIX vector support
  [SCSI] mpt3sas: Get IOC_FACTS information using handshake protocol
    only after HBA card gets into READY or Operational state.
  [SCSI] mpt3sas: Added module parameter 'unblock_io' to unblock IO's
    during disk addition
  [SCSI] mpt3sas: Remove redundancy code while freeing the controller
    resources.
  [SCSI] mpt3sas: MPI 2.5 Rev I (2.5.4) specifications.
  [SCSI] mpt3sas: Provides the physical location of sas drives
  [SCSI] mpt3sas: Bump mpt3sas Driver version to v5.100.00.00
  [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
  [SCSI] mpt3sas: MPI 2.5 Rev J (2.5.5) specification and 2.00.34 header
    files
  [SCSI] mpt3sas: Add branding string support for OEM's HBA
  [SCSI] mpt3sas: Add branding string support for OEM custom HBA
  [SCSI] mpt3sas: Bump mpt3sas driver version to v6.100.00.00
  [SCSI] mpt3sas: MPI 2.5 Rev K (2.5.6) specifications
  [SCSI] mpt3sas: Complete the SCSI command with DID_RESET status for
    log_info value 0x0x32010081
  [SCSI] mpt3sas: Return host busy error status to SML when DMA mapping
    of scatter gather list fails for a SCSI command
  [SCSI] mpt3sas: Added support for customer specific branding
  [SCSI] mpt3sas: Use alloc_ordered_workqueue() API instead of
    create_singlethread_workqueue() API
  [SCSI] mpt3sas: Call dma_mapping_error() API after mapping an address
    with dma_map_single() API
  [SCSI] mpt3sas: When device is blocked followed by unblock fails,
    unfreeze the I/Os
  [SCSI] mpt3sas : Bump mpt3sas driver version to 9.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  52 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |   4 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 284 +++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  48 +++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 399 ++++++++++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
 8 files changed, 708 insertions(+), 109 deletions(-)

-- 
2.0.2

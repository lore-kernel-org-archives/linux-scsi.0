From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.8+ merge window
Date: Fri, 01 Mar 2013 09:19:59 +0000
Message-ID: <1362129599.2384.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is an assorted set of stragglers into the merge window with driver
updates for qla2xxx, megaraid_sas, storvsc and ufs.  It also includes
pulls of the uapi tree (all the remaining SCSI pieces) and the fcoe tree
(updates to fcoe and libfc)

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-for-linus

The short changelog is:

Adam Radford (3):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Dont load DevHandle unless FastPath enabled
      megaraid_sas: Add 4k FastPath DIF support

Al Viro (1):
      debris left by " libfcoe: Remove mutex_trylock/restart_syscall checks"

Andrew Vasquez (2):
      qla2xxx: Correct list-iteration bug in Report-ID Acquisition codes.
      qla2xxx: Correct race in loop_state assignment during reset handling.

Arun Easi (3):
      qla2xxx: Prevent enabling target mode for unsupported HBAs.
      qla2xxx: Allow ISP81xx to create ATIO queues.
      qla2xxx: Enable target mode support for ISP83xx.

Bhanu Prakash Gollapudi (2):
      libfcoe: Check for unusable FCFs before looking for conflicting FCFs
      libfcoe: Handle CVL while waiting to select an FCF

Brian King (1):
      ipr: Fix oops while resetting an ipr adapter

Chad Dupuis (8):
      qla2xxx: Wait for IDC complete event to finish loopback operation.
      qla2xxx: Don't process RSCNs for a vport on the same physical adapter.
      qla2xxx: Move loopback mode reset after chip reset check.
      qla2xxx: Extra loopback error handling for ISP83xx.
      qla2xxx: Unload hangs after issuing BSG commands to vport.
      qla2xxx: Reject loopback request if one is already in progress.
      qla2xxx: Ramp down queue depth for attached SCSI devices when driver resources are low.
      qla2xxx: Determine the number of outstanding commands based on available resources.

Dan Carpenter (3):
      dc395x: uninitialized variable in device_alloc()
      libosd: check for kzalloc() failure
      qla4xxx: don't free NULL dma pool

David Howells (2):
      UAPI: (Scripted) Disintegrate include/scsi/fc
      UAPI: (Scripted) Disintegrate include/scsi

Giridhar Malavali (1):
      qla2xxx: Update the FTP site references in the driver sources.

Hiral Patel (5):
      fnic: Fnic Trace Utility
      fnic: New debug flags and debug log messages
      fnic: fnic driver may hit BUG_ON on device reset
      fnic: Fix SGEs limit
      fnic: fixing issues in device and firmware reset code

Joe Carnuccio (7):
      qla2xxx: Integrate generic card temperature with mezz card temperature.
      qla2xxx: Add setting of driver version string for vendor application.
      qla2xxx: Correction of comment in MBC opcode defines.
      Revert "[SCSI] qla2xxx: Optimize existing port name server query matching."
      Revert "[SCSI] qla2xxx: Avoid losing any fc ports when loop id's are exhausted."
      qla2xxx: Do link initialization on get loop id failure.
      qla2xxx: Print thermal unsupported message.

K. Y. Srinivasan (3):
      storvsc: Handle dynamic resizing of the device
      storvsc: Restructure error handling code on command completion
      storvsc: Initialize the sglist

Krishna Mohan (1):
      libfc: XenServer fails to mount root filesystem.

Martin K. Petersen (1):
      Fix range check in scsi_host_dif_capable()

Masanari Iida (1):
      qla2xxx: Avoid null pointer dereference in shutdown routine.

Neerav Parikh (1):
      fcoe: Fix deadlock while deleting FCoE interface with NPIV ports

Neil Horman (1):
      fcoe: close race on link speed detection in fcoe code

Olaf Hering (1):
      storvsc: avoid usage of WRITE_SAME

Paul Bolle (2):
      aacraid: suppress two GCC warnings
      qla2xxx: silence two GCC warnings.

Randy Dunlap (1):
      scsi: fix lpfc build when wmb() is defined as mb()

Robert Love (7):
      libfc, libfcoe, fcoe: Convert debug_logging macros to pr_info
      bnx2fc: Use the fcoe_sysfs control interface
      fcoe: Use the fcoe_sysfs control interface
      libfcoe, fcoe, bnx2fc: Add new fcoe control interface
      libfcoe: Add fcoe_sysfs debug logging level
      libfcoe: Save some memory and optimize name lookups
      Documentation: Add missing devices/ to devices path

Sakthivel K (1):
      pm80xx: fix for memory region free

Saurav Kashyap (6):
      qla2xxx: Don't process state change aen for reset owner.
      qla2xxx: Update the copyright information.
      qla2xxx: Display the lock owner on lock acquire failure.
      qla2xxx: Do MPI reset only for ISP81xx.
      qla2xxx: Get VPD information from common location for CNA.
      qla2xxx: Correction to the message ids.

Shuah Khan (1):
      hpsa: Check for dma_mapping_error in hpsa_map_one

Sreekanth Reddy (1):
      mpt2sas: Add support for OEM specific controller

Stephen M. Cameron (4):
      hpsa: check for dma_mapping_error in hpsa_passthru ioctls
      hpsa: reorganize error handling in hpsa_passthru_ioctl
      hpsa: check for dma_mapping_error in hpsa_map_sg_chain_block
      hpsa: Check for dma_mapping_error for all code paths using fill_cmd

Vasu Dev (1):
      libfc: fix REC handling

Vinayak Holikatti (2):
      ufs: Separate PCI code into glue driver
      ufs: Segregate PCI Specific Code

Xiangliang Yu (1):
      mvsas: fixed timeout issue when removing module

Yi Zou (7):
      bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly from libfcoe
      bnx2fc: use fcoe_link_speed_update() from the exported symbol in libfcoe
      bnx2fc: add support to get_netdev for bnx2f_interface
      libfcoe, fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
      libfcoe, fcoe: move fcoe_link_speed_update() to libfcoe and export it
      fcoe: add support to the get_netdev() for fcoe_interface
      fcoe: prep work to start consolidate the usage of fcoe_netdev

And the diffstat:

 Documentation/ABI/testing/sysfs-bus-fcoe    |  45 +-
 Documentation/scsi/ChangeLog.megaraid_sas   |   9 +
 drivers/scsi/aacraid/src.c                  |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           | 256 +++++-----
 drivers/scsi/dc395x.c                       |   2 +-
 drivers/scsi/fcoe/fcoe.c                    | 266 ++++++----
 drivers/scsi/fcoe/fcoe.h                    |   6 +-
 drivers/scsi/fcoe/fcoe_ctlr.c               |  45 +-
 drivers/scsi/fcoe/fcoe_sysfs.c              | 186 +++++--
 drivers/scsi/fcoe/fcoe_transport.c          | 199 +++++++-
 drivers/scsi/fcoe/libfcoe.h                 |  20 +-
 drivers/scsi/fnic/Makefile                  |   2 +
 drivers/scsi/fnic/fnic.h                    |  60 +++
 drivers/scsi/fnic/fnic_debugfs.c            | 314 ++++++++++++
 drivers/scsi/fnic/fnic_io.h                 |   6 +-
 drivers/scsi/fnic/fnic_main.c               |  17 +
 drivers/scsi/fnic/fnic_scsi.c               | 721 ++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic_trace.c              | 273 +++++++++++
 drivers/scsi/fnic/fnic_trace.h              |  90 ++++
 drivers/scsi/hpsa.c                         | 117 +++--
 drivers/scsi/ipr.c                          |  33 +-
 drivers/scsi/ipr.h                          |   1 +
 drivers/scsi/libfc/fc_fcp.c                 |   6 +-
 drivers/scsi/libfc/fc_libfc.h               |  38 +-
 drivers/scsi/libfc/fc_rport.c               |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  56 +--
 drivers/scsi/megaraid/megaraid_sas.h        |   6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   5 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   1 -
 drivers/scsi/mpt2sas/mpt2sas_base.c         |   8 +
 drivers/scsi/mpt2sas/mpt2sas_base.h         |   6 +
 drivers/scsi/mvsas/mv_sas.c                 |  10 +-
 drivers/scsi/mvsas/mv_sas.h                 |   1 +
 drivers/scsi/osd/osd_initiator.c            |   4 +
 drivers/scsi/pm8001/pm8001_init.c           |   3 +-
 drivers/scsi/qla2xxx/qla_attr.c             |  35 +-
 drivers/scsi/qla2xxx/qla_bsg.c              | 199 +++++---
 drivers/scsi/qla2xxx/qla_bsg.h              |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |  17 +-
 drivers/scsi/qla2xxx/qla_dbg.h              |   2 +-
 drivers/scsi/qla2xxx/qla_def.h              |  54 ++-
 drivers/scsi/qla2xxx/qla_dfs.c              |   2 +-
 drivers/scsi/qla2xxx/qla_fw.h               |   7 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |  15 +-
 drivers/scsi/qla2xxx/qla_gs.c               |  10 +-
 drivers/scsi/qla2xxx/qla_init.c             | 200 ++++++--
 drivers/scsi/qla2xxx/qla_inline.h           |  28 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |  39 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  82 +++-
 drivers/scsi/qla2xxx/qla_mbx.c              | 207 ++++++--
 drivers/scsi/qla2xxx/qla_mid.c              |   9 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  13 +-
 drivers/scsi/qla2xxx/qla_nx.h               |   4 +-
 drivers/scsi/qla2xxx/qla_os.c               | 147 +++++-
 drivers/scsi/qla2xxx/qla_settings.h         |   2 +-
 drivers/scsi/qla2xxx/qla_sup.c              |  18 +-
 drivers/scsi/qla2xxx/qla_target.c           | 169 ++++++-
 drivers/scsi/qla2xxx/qla_target.h           |  19 +-
 drivers/scsi/qla2xxx/qla_version.h          |   2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c              |   6 +-
 drivers/scsi/storvsc_drv.c                  | 137 ++++--
 drivers/scsi/ufs/Kconfig                    |  74 +--
 drivers/scsi/ufs/Makefile                   |   1 +
 drivers/scsi/ufs/ufs.h                      |  44 +-
 drivers/scsi/ufs/ufshcd-pci.c               | 211 ++++++++
 drivers/scsi/ufs/ufshcd.c                   | 423 ++++------------
 drivers/scsi/ufs/ufshcd.h                   | 202 ++++++++
 drivers/scsi/ufs/ufshci.h                   |  44 +-
 include/scsi/Kbuild                         |   3 -
 include/scsi/fc/Kbuild                      |   4 -
 include/scsi/fcoe_sysfs.h                   |  11 +-
 include/scsi/libfcoe.h                      |  32 +-
 include/scsi/scsi_host.h                    |   4 +-
 include/uapi/scsi/Kbuild                    |   3 +
 include/uapi/scsi/fc/Kbuild                 |   4 +
 include/{ => uapi}/scsi/fc/fc_els.h         |   0
 include/{ => uapi}/scsi/fc/fc_fs.h          |   0
 include/{ => uapi}/scsi/fc/fc_gs.h          |   0
 include/{ => uapi}/scsi/fc/fc_ns.h          |   0
 include/{ => uapi}/scsi/scsi_bsg_fc.h       |   0
 include/{ => uapi}/scsi/scsi_netlink.h      |   0
 include/{ => uapi}/scsi/scsi_netlink_fc.h   |   0
 83 files changed, 4100 insertions(+), 1205 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_debugfs.c
 create mode 100644 drivers/scsi/fnic/fnic_trace.c
 create mode 100644 drivers/scsi/fnic/fnic_trace.h
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h
 rename include/{ => uapi}/scsi/fc/fc_els.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_fs.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_gs.h (100%)
 rename include/{ => uapi}/scsi/fc/fc_ns.h (100%)
 rename include/{ => uapi}/scsi/scsi_bsg_fc.h (100%)
 rename include/{ => uapi}/scsi/scsi_netlink.h (100%)
 rename include/{ => uapi}/scsi/scsi_netlink_fc.h (100%)

James

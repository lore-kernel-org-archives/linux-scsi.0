From: Robert Love <robert.w.love@intel.com>
Subject: FCoE Updates for 3.8
Date: Wed, 12 Dec 2012 16:45:50 -0800
Message-ID: <20121213004550.GA19743@fritz.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab2LMApx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 19:45:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following changes since commit b69f0859dc8e633c5d8c06845811588fe17e68b3:

  Linux 3.7-rc8 (2012-12-03 11:22:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git for-next-12-12-12

for you to fetch changes up to 04f0ac991b5dd2a32c3fa3dcb2cf34830949afa5:

  debris left by "[SCSI] libfcoe: Remove mutex_trylock/restart_syscall checks" (2012-12-11 10:22:36 -0800)

----------------------------------------------------------------
Al Viro (1):
      debris left by "[SCSI] libfcoe: Remove mutex_trylock/restart_syscall checks"

Robert Love (7):
      Documentation: Add missing devices/ to devices path
      libfcoe: Save some memory and optimize name lookups
      libfcoe: Add fcoe_sysfs debug logging level
      libfcoe, fcoe, bnx2fc: Add new fcoe control interface
      fcoe: Use the fcoe_sysfs control interface
      bnx2fc: Use the fcoe_sysfs control interface
      libfc, libfcoe, fcoe: Convert debug_logging macros to pr_info

Vasu Dev (1):
      libfc: fix REC handling

Yi Zou (7):
      fcoe: prep work to start consolidate the usage of fcoe_netdev
      fcoe: add support to the get_netdev() for fcoe_interface
      libfcoe, fcoe: move fcoe_link_speed_update() to libfcoe and export it
      libfcoe, fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
      bnx2fc: add support to get_netdev for bnx2f_interface
      bnx2fc: use fcoe_link_speed_update() from the exported symbol in libfcoe
      bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly from libfcoe

 Documentation/ABI/testing/sysfs-bus-fcoe |   45 +++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  256 +++++++++++++++++-------------
 drivers/scsi/fcoe/fcoe.c                 |  212 +++++++++++++++----------
 drivers/scsi/fcoe/fcoe.h                 |    6 +-
 drivers/scsi/fcoe/fcoe_ctlr.c            |   17 +-
 drivers/scsi/fcoe/fcoe_sysfs.c           |  186 ++++++++++++++++++----
 drivers/scsi/fcoe/fcoe_transport.c       |  199 ++++++++++++++++++++++-
 drivers/scsi/fcoe/libfcoe.h              |   20 ++-
 drivers/scsi/libfc/fc_fcp.c              |    6 +-
 drivers/scsi/libfc/fc_libfc.h            |   38 ++---
 include/scsi/fcoe_sysfs.h                |   11 +-
 include/scsi/libfcoe.h                   |   32 +++-
 12 files changed, 749 insertions(+), 279 deletions(-)

From: "Love, Robert W" <robert.w.love@intel.com>
Subject: 3.9 request-pull for libfc, libfcoe and fcoe
Date: Tue, 19 Feb 2013 21:05:19 +0000
Message-ID: <5123E906.3060105@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21599 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933629Ab3BSVFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 16:05:21 -0500
Content-Language: en-US
Content-ID: <FF15464705BB2C44B93AFEBEC55AE657@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The following changes since commit 5b97fabdc815b4b60bac2328b58c5c7274debf58:

   libfc: fix REC handling (2012-12-04 10:16:38 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/for-next-02-19-13

for you to fetch changes up to 1f953b0dbc2549318afcc0a70af5542dffbce34a:

   libfcoe: Check for unusable FCFs before looking for conflicting FCFs 
(2013-02-19 12:23:07 -0800)

----------------------------------------------------------------
FCoE Updates for 3.9

----------------------------------------------------------------
Al Viro (1):
       debris left by "[SCSI] libfcoe: Remove 
mutex_trylock/restart_syscall checks"

Bhanu Prakash Gollapudi (2):
       libfcoe: Handle CVL while waiting to select an FCF
       libfcoe: Check for unusable FCFs before looking for conflicting FCFs

David Howells (1):
       UAPI: (Scripted) Disintegrate include/scsi/fc

Krishna Mohan (1):
       libfc: XenServer fails to mount root filesystem.

Neerav Parikh (1):
       fcoe: Fix deadlock while deleting FCoE interface with NPIV ports

Neil Horman (1):
       fcoe: close race on link speed detection in fcoe code

Robert Love (7):
       Documentation: Add missing devices/ to devices path
       libfcoe: Save some memory and optimize name lookups
       libfcoe: Add fcoe_sysfs debug logging level
       libfcoe, fcoe, bnx2fc: Add new fcoe control interface
       fcoe: Use the fcoe_sysfs control interface
       bnx2fc: Use the fcoe_sysfs control interface
       libfc, libfcoe, fcoe: Convert debug_logging macros to pr_info

Yi Zou (7):
       fcoe: prep work to start consolidate the usage of fcoe_netdev
       fcoe: add support to the get_netdev() for fcoe_interface
       libfcoe, fcoe: move fcoe_link_speed_update() to libfcoe and export it
       libfcoe, fcoe: consolidate the fcoe_ctlr_get_lesb/fcoe_get_lesb
       bnx2fc: add support to get_netdev for bnx2f_interface
       bnx2fc: use fcoe_link_speed_update() from the exported symbol in 
libfcoe
       bnx2fc: use fcoe_get_lesb/fcoe_ctlr_get_lesb() directly from libfcoe

  Documentation/ABI/testing/sysfs-bus-fcoe |   45 ++++-
  drivers/scsi/bnx2fc/bnx2fc_fcoe.c        |  256 
++++++++++++++++------------
  drivers/scsi/fcoe/fcoe.c                 |  266 
++++++++++++++++++++----------
  drivers/scsi/fcoe/fcoe.h                 |    6 +-
  drivers/scsi/fcoe/fcoe_ctlr.c            |   45 ++---
  drivers/scsi/fcoe/fcoe_sysfs.c           |  186 +++++++++++++++++----
  drivers/scsi/fcoe/fcoe_transport.c       |  199 +++++++++++++++++++++-
  drivers/scsi/fcoe/libfcoe.h              |   20 ++-
  drivers/scsi/libfc/fc_libfc.h            |   38 ++---
  drivers/scsi/libfc/fc_rport.c            |    2 +-
  include/scsi/fc/Kbuild                   |    4 -
  include/scsi/fcoe_sysfs.h                |   11 +-
  include/scsi/libfcoe.h                   |   32 +++-
  include/uapi/scsi/fc/Kbuild              |    4 +
  include/{ => uapi}/scsi/fc/fc_els.h      |    0
  include/{ => uapi}/scsi/fc/fc_fs.h       |    0
  include/{ => uapi}/scsi/fc/fc_gs.h       |    0
  include/{ => uapi}/scsi/fc/fc_ns.h       |    0
  18 files changed, 819 insertions(+), 295 deletions(-)
  rename include/{ => uapi}/scsi/fc/fc_els.h (100%)
  rename include/{ => uapi}/scsi/fc/fc_fs.h (100%)
  rename include/{ => uapi}/scsi/fc/fc_gs.h (100%)
  rename include/{ => uapi}/scsi/fc/fc_ns.h (100%)

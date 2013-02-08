From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/23] qla2xxx: Patches for scsi "misc" branch.
Date: Fri,  8 Feb 2013 01:57:41 -0500
Message-ID: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:48316 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759898Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.
This set needs to be applied on top of last submission.

Thanks,
~Saurav

Andrew Vasquez (2):
  qla2xxx: Correct race in loop_state assignment during reset handling.
  qla2xxx: Correct list-iteration bug in Report-ID Acquisition codes.

Chad Dupuis (6):
  qla2xxx: Reject loopback request if one is already in progress.
  qla2xxx: Unload hangs after issuing BSG commands to vport.
  qla2xxx: Extra loopback error handling for ISP83xx.
  qla2xxx: Move loopback mode reset after chip reset check.
  qla2xxx: Don't process RSCNs for a vport on the same physical
    adapter.
  qla2xxx: Wait for IDC complete event to finish loopback operation.

Giridhar Malavali (1):
  qla2xxx: Update the FTP site references in the driver sources.

Joe Carnuccio (7):
  qla2xxx: Print thermal unsupported message.
  qla2xxx: Do link initialization on get loop id failure.
  Revert "[SCSI] qla2xxx: Avoid losing any fc ports when loop id's are
    exhausted."
  Revert "[SCSI] qla2xxx: Optimize existing port name server query
    matching."
  qla2xxx: Correction of comment in MBC opcode defines.
  qla2xxx: Add setting of driver version string for vendor application.
  qla2xxx: Integrate generic card temperature with mezz card
    temperature.

Masanari Iida (1):
  qla2xxx: Avoid null pointer dereference in shutdown routine.

Paul Bolle (1):
  qla2xxx: silence two GCC warnings.

Saurav Kashyap (5):
  qla2xxx: Get VPD information from common location for CNA.
  qla2xxx: Do MPI reset only for ISP81xx.
  qla2xxx: Display the lock owner on lock acquire failure.
  qla2xxx: Update the copyright information.
  qla2xxx: Don't process state change aen for reset owner.

 drivers/scsi/qla2xxx/qla_attr.c     |   35 ++++---
 drivers/scsi/qla2xxx/qla_bsg.c      |  197 ++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_bsg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_dbg.c      |    8 +-
 drivers/scsi/qla2xxx/qla_dbg.h      |    2 +-
 drivers/scsi/qla2xxx/qla_def.h      |   24 +++--
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |    4 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   11 ++-
 drivers/scsi/qla2xxx/qla_gs.c       |   10 +-
 drivers/scsi/qla2xxx/qla_init.c     |  138 ++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_inline.h   |    9 ++-
 drivers/scsi/qla2xxx/qla_iocb.c     |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c      |   52 ++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c      |  199 ++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_mid.c      |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c       |   11 ++-
 drivers/scsi/qla2xxx/qla_nx.h       |    4 +-
 drivers/scsi/qla2xxx/qla_os.c       |   24 +++--
 drivers/scsi/qla2xxx/qla_settings.h |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c      |   18 +---
 drivers/scsi/qla2xxx/qla_version.h  |    2 +-
 22 files changed, 539 insertions(+), 219 deletions(-)

-- 
1.7.7


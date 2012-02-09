From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/29] qla2xxx: Patches for scsi-misc.
Date: Thu, 9 Feb 2012 11:15:32 -0800
Message-ID: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:39296
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758405Ab2BITcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:09 -0500
Received: from mail71-ch1 (localhost [127.0.0.1])	by mail71-ch1-R.bigfish.com
 (Postfix) with ESMTP id B045460502	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:08 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to scsi-misc-2.6 at your
earliest convenience for inclusion in the next mainline merge window.

Thanks,
Chad

Andrew Vasquez (6):
  qla2xxx: Use a valid enode-mac if none defined.
  qla2xxx: Use consistent DL mask for ELS/CT passthru requests.
  qla2xxx: Perform implicit logout during rport tear-down.
  qla2xxx: Prep zero-length BSG data-transfer requests.
  qla2xxx: Reduce mbx-command timeout for Login/Logout requests.
  qla2xxx: Cache swl during fabric discovery.

Arun Easi (8):
  qla2xxx: Handle change notifications based on switch scan results.
  qla2xxx: Fix ql_dbg arguments.
  qla2xxx: Add new message when a new loopid is assigned.
  qla2xxx: Log messages to use correct vha.
  qla2xxx: Handle device mapping changes due to device logout.
  qla2xxx: Fix incorrect register access in qla2x00_start_iocbs().
  qla2xxx: Stop iteration after first failure in *_id functions.
  qla2xxx: Avoid invalid request queue dereference for bad response
    packets.

Chad Dupuis (8):
  qla2xxx: Increase speed of flash access in ISP82xx adapters to
    improve firmware load speed.
  qla2xxx: Handle failure cases during fabric_login
  qla2xxx: Print mailbox command opcode and return code when a command
    times out.
  qla2xxx: Convert remaining printk's to ql_log format.
  qla2xxx: Use ql_log* #define's in ql_log() and ql_log_pci().
  qla2xxx: Perform firmware dump procedure on mailbox command timeout.
  qla2xxx: Update LICENSE.qla2xxx.
  qla2xxx: Add ha->max_fibre_devices to keep track of the maximum
    number of targets.

Giridhar Malavali (4):
  qla2xxx: Enhanced the dump routines to capture multiple request and
    response queues.
  qla2xxx: Enhancements to support ISP83xx.
  qla2xxx: Consolidation of SRB processing.
  qla2xxx: Change the log message when previous dump is available to
    retrieve for ISP82xx.

Joe Carnuccio (3):
  qla2xxx: Correct print format for edc ql_log() calls.
  qla2xxx: Return blank sysfs string on initial get thermal failure.
  qla2xxx: Remove EDC sysfs interface.

 Documentation/scsi/LICENSE.qla2xxx |   41 +---
 drivers/scsi/qla2xxx/qla_attr.c    |  177 ++---------
 drivers/scsi/qla2xxx/qla_bsg.c     |  120 ++++----
 drivers/scsi/qla2xxx/qla_dbg.c     |  630 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_dbg.h     |   63 ++++
 drivers/scsi/qla2xxx/qla_def.h     |  117 ++++---
 drivers/scsi/qla2xxx/qla_dfs.c     |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h      |   13 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   22 +-
 drivers/scsi/qla2xxx/qla_gs.c      |   84 ++++--
 drivers/scsi/qla2xxx/qla_init.c    |  540 ++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_inline.h  |   51 +++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  167 +++++-----
 drivers/scsi/qla2xxx/qla_isr.c     |  445 +++++++++++---------------
 drivers/scsi/qla2xxx/qla_mbx.c     |  410 ++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c      |   90 ++---
 drivers/scsi/qla2xxx/qla_nx.h      |    3 +-
 drivers/scsi/qla2xxx/qla_os.c      |  432 ++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_sup.c     |  148 ++++++++-
 20 files changed, 2197 insertions(+), 1360 deletions(-)



From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 00/17] qla2xxx: Cleanup and minor fixes
Date: Tue, 30 May 2017 10:54:15 -0700
Message-ID: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0078.outbound.protection.outlook.com ([104.47.42.78]:54825
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750912AbdE3Ryu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:54:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

This series contains patches that were dropped from 4.12.0-rc3 inclusion, since
they can go to 4.13 merge window.

Changes from v1 --> v2
o addressed 0-day kernel warning.
o addressed cleanups and updates as per Bart's comments.
o added Acked-by tag from Nicholas to applicable patches.

Please apply this series to for-next branch to be included in 4.13 merge window.

Thanks,
Himanshu 

Joe Carnuccio (1):
  qla2xxx: Retain loop test for fwdump length exceeding buffer length

Quinn Tran (15):
  qla2xxx: Allow ABTS RX, RIDA on ATIOQ for ISP83XX/27XX
  qla2xxx: Replace usage of spin_lock with spin_lock_irqsave
  qla2xxx: Include Exchange offload/Extended Login into FW dump
  qla2xxx: Fix path recovery
  tcm_qla2xxx: Do not allow aborted cmd to advance.
  qla2xxx: Convert 32-bit LUN usage to 64-bit
  qla2xxx: Fix name server relogin
  qla2xxx: Cleanup debug message IDs
  qla2xxx: Turn on FW option for exchange check
  qla2xxx: Add ql2xiniexchg parameter
  qla2xxx: Remove redundant code
  qla2xxx: Remove redundant wait when target is stopped.
  qla2xxx: Accelerate SCSI BUSY status generation in target mode
  qla2xxx: Remove unused irq_cmd_count field.
  qla2xxx: Remove extra register read

Sawan Chandak (1):
  qla2xxx: Use flag PFLG_DISCONNECTED.

 drivers/scsi/qla2xxx/qla_attr.c    |   2 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   2 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  53 ++++-
 drivers/scsi/qla2xxx/qla_dbg.h     |  12 +
 drivers/scsi/qla2xxx/qla_def.h     |   9 +-
 drivers/scsi/qla2xxx/qla_dfs.c     |   8 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   3 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 141 +++++++-----
 drivers/scsi/qla2xxx/qla_init.c    | 379 ++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_inline.h  |  16 ++
 drivers/scsi/qla2xxx/qla_iocb.c    |   4 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  35 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  73 +++---
 drivers/scsi/qla2xxx/qla_os.c      | 167 +++++++++-----
 drivers/scsi/qla2xxx/qla_target.c  | 441 ++++++++++++++++---------------------
 drivers/scsi/qla2xxx/qla_target.h  |   7 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  16 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  15 +-
 18 files changed, 796 insertions(+), 587 deletions(-)

-- 
2.12.0

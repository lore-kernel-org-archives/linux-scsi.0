From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 0/7] qla2xxx: Bug Fixes for driver.
Date: Wed, 24 May 2017 18:06:17 -0700
Message-ID: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0056.outbound.protection.outlook.com ([104.47.41.56]:37475
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1161998AbdEYBG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

I have reduced the series for 4.12 rc merge to 1-10 patches that
were submitted earlier.

Changes from v1 --> v2
o Drop patches that can be queued for 4.13 scsi-misc merge and will be
  sent as new series.
o Addressed commit summary of patches from Bart's review where applicable.

Please include them in 4.12.0-rc3 fixes at your earliest convenience.

Thanks,
Himanshu

Himanshu Madhani (1):
  qla2xxx: Fix recursive loop during target mode configuration for
    ISP25XX leaving system unresponsive.

Joe Carnuccio (4):
  qla2xxx: Modify T262 FW dump template to specify same start/end to
    debug customer issues.
  qla2xxx: Set bit 15 for DIAG_ECHO_TEST MBC.
  qla2xxx: Fix mailbox pointer error in fwdump capture.
  qla2xxx: Fix crash due to NULL pointer dereference of ctx.

Quinn Tran (1):
  qla2xxx: Fix NULL pointer access due to redundant fc_host_port_name
    call

Sawan Chandak (1):
  qla2xxx: Fix crash due to mismatch mumber of Q-pair creation for Multi
    queue

 drivers/scsi/qla2xxx/qla_bsg.c    |  9 +++++----
 drivers/scsi/qla2xxx/qla_dbg.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_init.c   |  5 ++++-
 drivers/scsi/qla2xxx/qla_inline.h | 26 +++++++-------------------
 drivers/scsi/qla2xxx/qla_isr.c    |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c    | 13 ++-----------
 drivers/scsi/qla2xxx/qla_os.c     | 30 +++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c |  8 +++++---
 drivers/scsi/qla2xxx/qla_tmpl.c   |  2 +-
 10 files changed, 47 insertions(+), 53 deletions(-)

-- 
2.12.0

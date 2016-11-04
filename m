From: <himanshu.madhani@cavium.com>
Subject: [PATCH 0/4] qla2xxx: feature updates for driver.
Date: Fri, 4 Nov 2016 09:33:29 -0700
Message-ID: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:9056
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932299AbcKDTGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Nov 2016 15:06:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Hi Martin, 

This series contains support for Multiqueue feature. Also, improved
command submission via mailbox path in the driver.

Please apply to scsi-misc at your earliest convenience.

Thanks,
Himanshu  


Himanshu Madhani (1):
  qla2xxx: Only allow operational MBX to proceed during RESET.

Michael Hernandez (1):
  qla2xxx: Add Block Multi Queue functionality.

Quinn Tran (1):
  qla2xxx: Fix Target stack handling with Multi-queue changes

Samy (1):
  qla2xxx: Fix mailbox command timeout due to starvation

 drivers/scsi/qla2xxx/Makefile     |   3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
 drivers/scsi/qla2xxx/qla_bottom.c | 398 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 118 +++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  34 +++-
 drivers/scsi/qla2xxx/qla_init.c   |  14 +-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
 drivers/scsi/qla2xxx/qla_isr.c    | 104 ++++------
 drivers/scsi/qla2xxx/qla_mbx.c    | 176 ++++++++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
 drivers/scsi/qla2xxx/qla_mq.c     | 278 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     | 326 +++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_target.c |   4 +
 drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
 16 files changed, 1419 insertions(+), 373 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
 create mode 100644 drivers/scsi/qla2xxx/qla_top.c

-- 
1.8.3.1


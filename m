From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH 0/2] qla2xxx: Couple bug fixes for FC-NVMe
Date: Fri, 13 Oct 2017 15:43:21 -0700
Message-ID: <20171013224323.14863-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:4224
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752761AbdJMWnd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 18:43:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Hi Martin, 

This series has couple bug fixes for FC-NVMe code path. Please apply 
them to 4.15/scsi-queue at your earliest convenience.

Thanks,
Himanshu

Giridhar Malavali (1):
  qla2xxx: Query FC4 type during RSCN processing

Himanshu Madhani (1):
  qla2xxx: Use ql2xnvmeenable to enable Q-Pair for FC-NVMe

 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |  2 +-
 drivers/scsi/qla2xxx/qla_mid.c  |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 29 +++++++++++++++++++----------
 4 files changed, 22 insertions(+), 13 deletions(-)

-- 
2.12.0

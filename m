From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/2] qla2xxx: Bug fixes for driver
Date: Thu, 1 Feb 2018 10:33:16 -0800
Message-ID: <20180201183318.587-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0050.outbound.protection.outlook.com ([104.47.32.50]:41303
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751567AbeBASdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Feb 2018 13:33:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

These are couple of bug fixes for the driver. 

Patch#1 is the issue reported by Max using KASAN tool.
Patch#2 fixes use of wrong queue handle for abort IOCB. 

Please apply them to 4.16/scsi-fixes at your earliest convenience.

Thanks,
Himanshu 

Himanshu Madhani (1):
  qla2xxx: Fix incorrect handle for abort IOCB

Quinn Tran (1):
  qla2xxx: Fix double free bug after firmware timeout

 drivers/scsi/qla2xxx/qla_init.c | 23 +++--------------------
 drivers/scsi/qla2xxx/qla_iocb.c |  7 +++----
 2 files changed, 6 insertions(+), 24 deletions(-)

-- 
2.12.0

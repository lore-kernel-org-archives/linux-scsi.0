From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/2] qla2xxx: fixes for the driver
Date: Mon, 22 Jan 2018 12:04:18 -0800
Message-ID: <20180122200420.19516-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0046.outbound.protection.outlook.com ([104.47.40.46]:63053
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751021AbeAVUGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jan 2018 15:06:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series has small fixes for the driver. 

Please apply to 4.16/scsi-queue.

Thanks,
Himanshu

Himanshu Madhani (2):
  qla2xxx: Fix warning reported for req_que_no in qla24xx_async_cmd()
  qla2xxx: Fix logo flag for qlt_free_session_done()

 drivers/scsi/qla2xxx/qla_init.c   | 5 +++--
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.12.0

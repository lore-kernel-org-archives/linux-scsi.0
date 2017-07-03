From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qedi: fix another spelling mistake: "alloction" -> "allocation"
Date: Mon,  3 Jul 2017 11:24:02 +0100
Message-ID: <20170703102402.12853-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54522 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdGCKYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2017 06:24:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in QEDF_ERR message.  I should have
also included this in a previous fix, but I only just spotted this one.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 19254bd739d9..93d54acd4a22 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1411,7 +1411,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
 	if (!list_work) {
-		QEDI_ERR(&qedi->dbg_ctx, "Memory alloction failed\n");
+		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto abort_ret;
 	}
 
-- 
2.11.0

From: Ding Xiang <dingxiang@cmss.chinamobile.com>
Subject: [PATCH] scsi: bnx2fc: remove unneeded variable
Date: Fri, 29 Mar 2019 11:24:12 +0800
Message-ID: <1553829852-16525-1-git-send-email-dingxiang@cmss.chinamobile.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"rc" is unneeded,just return SUCCESS

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index bc9f2a2..8def63c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1083,7 +1083,6 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
-	int rc = SUCCESS;
 	unsigned int time_left;
 
 	io_req->wait_for_comp = 1;
@@ -1110,7 +1109,7 @@ static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 
 	spin_lock_bh(&tgt->tgt_lock);
-	return rc;
+	return SUCCESS;
 }
 
 /**
-- 
1.9.1

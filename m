From: Colin King <colin.king@canonical.com>
Subject: [PATCH] bnx2i: fix spelling mistake "complection" -> "completion"
Date: Sat,  4 Jun 2016 20:14:30 +0100
Message-ID: <1465067670-7489-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in printk message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index fb072cc..42921db 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2417,7 +2417,7 @@ static void bnx2i_process_conn_destroy_cmpl(struct bnx2i_hba *hba,
 	ep = bnx2i_find_ep_in_destroy_list(hba, conn_destroy->iscsi_conn_id);
 	if (!ep) {
 		printk(KERN_ALERT "bnx2i_conn_destroy_cmpl: no pending "
-				  "offload request, unexpected complection\n");
+				  "offload request, unexpected completion\n");
 		return;
 	}
 
-- 
2.8.1

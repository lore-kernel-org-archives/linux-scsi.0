From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bnx2fc: remove redundant assignment to variable rc
Date: Thu,  4 Jul 2019 16:40:35 +0100
Message-ID: <20190704154035.15233-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable rc is being initialized with a value that is never
read and it is being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 7796799bf04a..4eb3fe9ed189 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1893,7 +1893,7 @@ static void bnx2fc_stop(struct bnx2fc_interface *interface)
 static int bnx2fc_fw_init(struct bnx2fc_hba *hba)
 {
 #define BNX2FC_INIT_POLL_TIME		(1000 / HZ)
-	int rc = -1;
+	int rc;
 	int i = HZ;
 
 	rc = bnx2fc_bind_adapter_devices(hba);
-- 
2.20.1

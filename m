From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fix spelling mistake in error message
Date: Mon,  7 Nov 2016 16:38:57 +0000
Message-ID: <20161107163857.23766-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "operatio" to "operation"
in critical error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/dpt_i2o.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 21c8d21..d84004b 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -3350,7 +3350,7 @@ static int adpt_i2o_query_scalar(adpt_hba* pHba, int tid,
 	if (opblk_va == NULL) {
 		dma_free_coherent(&pHba->pDev->dev, sizeof(u8) * (8+buflen),
 			resblk_va, resblk_pa);
-		printk(KERN_CRIT "%s: query operatio failed; Out of memory.\n",
+		printk(KERN_CRIT "%s: query operation failed; Out of memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
-- 
2.9.3

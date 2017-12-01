From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: ipr: fix incorrect indentation of assignment statement
Date: Fri,  1 Dec 2017 13:33:27 +0000
Message-ID: <20171201133327.15515-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Remove one extraneous level of indentation on an assignment statement.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index cc0187965eee..e07dd990e585 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9653,8 +9653,8 @@ static int ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 			if (i == 0) {
 				entries_each_hrrq = IPR_NUM_INTERNAL_CMD_BLKS;
 				ioa_cfg->hrrq[i].min_cmd_id = 0;
-					ioa_cfg->hrrq[i].max_cmd_id =
-						(entries_each_hrrq - 1);
+				ioa_cfg->hrrq[i].max_cmd_id =
+					(entries_each_hrrq - 1);
 			} else {
 				entries_each_hrrq =
 					IPR_NUM_BASE_CMD_BLKS/
-- 
2.14.1

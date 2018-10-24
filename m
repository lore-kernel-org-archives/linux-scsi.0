From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] NCR5380: Return false instead of NULL
Date: Wed, 24 Oct 2018 18:45:33 +1100
Message-ID: <2e765651c37d951fb424eb966e1a91ff08c8391b.1540367133.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I overlooked this statement when I recently converted the function result
type from struct scsi_cmnd * to bool. No change to object code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8429c855701f..01c23d27f290 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1198,7 +1198,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 out:
 	if (!hostdata->selecting)
-		return NULL;
+		return false;
 	hostdata->selecting = NULL;
 	return ret;
 }
-- 
2.18.1

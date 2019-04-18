From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aic7xxx: fix spelling mistake "recevied" -> "received"
Date: Thu, 18 Apr 2019 11:20:25 +0100
Message-ID: <20190418102025.10021-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a kernel message, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index d4a7263e4b8f..a9d40d3b90ef 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1666,7 +1666,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 					printk("\tCRC Value Mismatch\n");
 				if ((sstat2 & CRCENDERR) != 0)
 					printk("\tNo terminal CRC packet "
-					       "recevied\n");
+					       "received\n");
 				if ((sstat2 & CRCREQERR) != 0)
 					printk("\tIllegal CRC packet "
 					       "request\n");
-- 
2.20.1

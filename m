From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: myrs: Fix spelling mistake: "Cashe"-> "Cache"
Date: Wed, 14 Feb 2018 10:30:43 +0000
Message-ID: <20180214103043.3112-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in info message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/myrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b87c6942a8e..16498e1b0dd4 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1571,7 +1571,7 @@ static ssize_t myrs_store_flush_cache(struct device *dev,
 		return count;
 	}
 	shost_printk(KERN_INFO, shost,
-		     "Cashe Flush failed, status 0x%02x\n", status);
+		     "Cache Flush failed, status 0x%02x\n", status);
 	return -EIO;
 }
 static DEVICE_ATTR(flush_cache, S_IWUSR, NULL, myrs_store_flush_cache);
-- 
2.15.1


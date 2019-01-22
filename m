From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: atp870u: clean up code style and indentation issues
Date: Tue, 22 Jan 2019 15:10:30 +0000
Message-ID: <20190122151030.7007-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Clean up { brace to fix cppcheck warning. Remove some trailing spaces
at end of a statement.  Also clean up an indentation issue.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/atp870u.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 1267200380f8..446a789cdaf5 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -194,12 +194,11 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 				((unsigned char *) &adrcnt)[2] = atp_readb_io(dev, c, 0x12);
 				((unsigned char *) &adrcnt)[1] = atp_readb_io(dev, c, 0x13);
 				((unsigned char *) &adrcnt)[0] = atp_readb_io(dev, c, 0x14);
-				if (dev->id[c][target_id].last_len != adrcnt)
-				{
-			   		k = dev->id[c][target_id].last_len;
+				if (dev->id[c][target_id].last_len != adrcnt) {
+					k = dev->id[c][target_id].last_len;
 			   		k -= adrcnt;
 			   		dev->id[c][target_id].tran_len = k;			   
-			   	dev->id[c][target_id].last_len = adrcnt;			   
+					dev->id[c][target_id].last_len = adrcnt;
 				}
 #ifdef ED_DBGP
 				printk("dev->id[c][target_id].last_len = %d dev->id[c][target_id].tran_len = %d\n",dev->id[c][target_id].last_len,dev->id[c][target_id].tran_len);
-- 
2.19.1

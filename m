From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: dpt_i2o: clean up indentation issues, remove spaces
Date: Wed, 23 Jan 2019 12:53:19 +0000
Message-ID: <20190123125319.17193-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several lines where the indentation has an extra space,
fix this by removing the spaces.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/dpt_i2o.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 70d1a18278af..f9560a183c12 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -877,8 +877,8 @@ static void adpt_i2o_sys_shutdown(void)
 	adpt_hba *pHba, *pNext;
 	struct adpt_i2o_post_wait_data *p1, *old;
 
-	 printk(KERN_INFO"Shutting down Adaptec I2O controllers.\n");
-	 printk(KERN_INFO"   This could take a few minutes if there are many devices attached\n");
+	printk(KERN_INFO "Shutting down Adaptec I2O controllers.\n");
+	printk(KERN_INFO "   This could take a few minutes if there are many devices attached\n");
 	/* Delete all IOPs from the controller chain */
 	/* They should have already been released by the
 	 * scsi-core
@@ -901,7 +901,7 @@ static void adpt_i2o_sys_shutdown(void)
 //	spin_unlock_irqrestore(&adpt_post_wait_lock, flags);
 	adpt_post_wait_queue = NULL;
 
-	 printk(KERN_INFO "Adaptec I2O controllers down.\n");
+	printk(KERN_INFO "Adaptec I2O controllers down.\n");
 }
 
 static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
@@ -3427,7 +3427,7 @@ static int adpt_i2o_issue_params(int cmd, adpt_hba* pHba, int tid,
 		return -((res[1] >> 16) & 0xFF); /* -BlockStatus */
 	}
 
-	 return 4 + ((res[1] & 0x0000FFFF) << 2); /* bytes used in resblk */ 
+	return 4 + ((res[1] & 0x0000FFFF) << 2); /* bytes used in resblk */
 }
 
 
@@ -3500,8 +3500,8 @@ static int adpt_i2o_enable_hba(adpt_hba* pHba)
 
 static int adpt_i2o_systab_send(adpt_hba* pHba)
 {
-	 u32 msg[12];
-	 int ret;
+	u32 msg[12];
+	int ret;
 
 	msg[0] = I2O_MESSAGE_SIZE(12) | SGL_OFFSET_6;
 	msg[1] = I2O_CMD_SYS_TAB_SET<<24 | HOST_TID<<12 | ADAPTER_TID;
-- 
2.19.1

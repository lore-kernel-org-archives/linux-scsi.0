From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: gdth: fix indentation issue, remove a tab
Date: Fri,  4 Jan 2019 17:10:25 +0000
Message-ID: <20190104171025.8448-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A goto statement is indented incorrectly, fix this by removing a tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/gdth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 194c294f9b6c..159a4e301c4d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -5039,7 +5039,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, gdth_ha_str **ha_out)
 		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "GDT-PCI %d: "
 				"Unable to set 32-bit DMA\n", ha->hanum);
-				goto out_free_coal_stat;
+			goto out_free_coal_stat;
 		}
 	} else {
 		shp->max_cmd_len = 16;
-- 
2.19.1

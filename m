From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mvsas: clean up a few indentation issues
Date: Sat,  2 Feb 2019 10:30:35 +0000
Message-ID: <20190202103035.16043-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a few statements that are not indented correctly,
so fix these. Also add empty line between variable declaration and
first statements in functions. Also remove whitespace between *
and mvi_dev to clean up a cppcheck warning.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mvsas/mv_64xx.c | 3 ++-
 drivers/scsi/mvsas/mv_94xx.c | 3 ++-
 drivers/scsi/mvsas/mv_sas.c  | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index b757d389e32f..2c699bc785a8 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -678,7 +678,8 @@ static u32 mvs_64xx_spi_read_data(struct mvs_info *mvi)
 static void mvs_64xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs = mvi->regs_ex;
-	 iow32(SPI_DATA_REG_64XX, data);
+
+	iow32(SPI_DATA_REG_64XX, data);
 }
 
 
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.c
index eb5471bc7263..68b5b5f39a03 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -946,7 +946,8 @@ static u32 mvs_94xx_spi_read_data(struct mvs_info *mvi)
 static void mvs_94xx_spi_write_data(struct mvs_info *mvi, u32 data)
 {
 	void __iomem *regs = mvi->regs_ex - 0x10200;
-	 mw32(SPI_RD_DATA_REG_94XX, data);
+
+	mw32(SPI_RD_DATA_REG_94XX, data);
 }
 
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 311d23c727ce..e205e4057e6f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1422,7 +1422,7 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
 {
 	unsigned long flags;
 	int rc = TMF_RESP_FUNC_FAILED;
-    struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (mvi_dev->dev_status != MVS_DEV_EH)
-- 
2.20.1

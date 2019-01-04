From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: csiostor: fix two minor indentation issues
Date: Fri,  4 Jan 2019 17:06:24 +0000
Message-ID: <20190104170624.8287-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Two statements are indented incorrectly, fix these by removing
a tab and a space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/csiostor/csio_mb.c   | 2 +-
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 6f13673d6aa0..94810b19e747 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1210,7 +1210,7 @@ csio_mb_issue(struct csio_hw *hw, struct csio_mb *mbp)
 		   !csio_is_hw_intr_enabled(hw)) {
 		csio_err(hw, "Cannot issue mailbox in interrupt mode 0x%x\n",
 			 *((uint8_t *)mbp->mb));
-			goto error_out;
+		goto error_out;
 	}
 
 	if (mbm->mcurrent != NULL) {
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index bc5547a62c00..c7db0777300a 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1383,7 +1383,7 @@ csio_device_reset(struct device *dev,
 		return -EINVAL;
 
 	/* Delete NPIV lnodes */
-	 csio_lnodes_exit(hw, 1);
+	csio_lnodes_exit(hw, 1);
 
 	/* Block upper IOs */
 	csio_lnodes_block_request(hw);
-- 
2.19.1

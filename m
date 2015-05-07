From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] scsi:treewide: Fix typo in drivers/scsi
Date: Thu,  7 May 2015 23:21:27 +0900
Message-ID: <1431008487-5123-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch fix spme spelling typos in printk
within drivers/scsi.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/53c700.c               | 2 +-
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 drivers/scsi/scsi_transport_spi.c   | 4 ++--
 drivers/scsi/wd719x.c               | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 82abfce..a209c34 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -299,7 +299,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	memory = dma_alloc_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
 				       &pScript, GFP_KERNEL);
 	if(memory == NULL) {
-		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detatching\n");
+		printk(KERN_ERR "53c700: Failed to allocate memory for driver, detaching\n");
 		return NULL;
 	}
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 67d43e3..73d6a61 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3035,7 +3035,7 @@ iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 
 	shost = scsi_host_lookup(ev->u.get_chap.host_no);
 	if (!shost) {
-		printk(KERN_ERR "%s: failed. Cound not find host no %u\n",
+		printk(KERN_ERR "%s: failed. Could not find host no %u\n",
 		       __func__, ev->u.get_chap.host_no);
 		return -ENODEV;
 	}
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 31bbb0d..319868f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -786,10 +786,10 @@ spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
 		 * IU, then QAS (if we can control them), then finally
 		 * fall down the periods */
 		if (i->f->set_iu && spi_iu(starget)) {
-			starget_printk(KERN_ERR, starget, "Domain Validation Disabing Information Units\n");
+			starget_printk(KERN_ERR, starget, "Domain Validation Disabling Information Units\n");
 			DV_SET(iu, 0);
 		} else if (i->f->set_qas && spi_qas(starget)) {
-			starget_printk(KERN_ERR, starget, "Domain Validation Disabing Quick Arbitration and Selection\n");
+			starget_printk(KERN_ERR, starget, "Domain Validation Disabling Quick Arbitration and Selection\n");
 			DV_SET(qas, 0);
 		} else {
 			newperiod = spi_period(starget);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 289ad01..c8e74d3 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -590,7 +590,7 @@ static inline void wd719x_interrupt_SCB(struct wd719x *wd,
 		dev_dbg(&wd->pdev->dev, "selection timeout\n");
 		break;
 	case WD719X_SUE_RESET:
-		dev_dbg(&wd->pdev->dev, "bus reset occured\n");
+		dev_dbg(&wd->pdev->dev, "bus reset occurred\n");
 		result = DID_RESET;
 		break;
 	case WD719X_SUE_BUSERROR:
-- 
2.4.0.rc3.3.g6eb1401

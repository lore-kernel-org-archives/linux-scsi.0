From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] drivers/scsi/lpfc/lpfc_hw.h: Some minor cleanup.
Date: Tue, 30 Oct 2007 11:54:32 +0100 (MET)
Message-ID: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756064AbXJ3LFL@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com, James.Smart@emulex.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Diffed against linus-git
Checked with script/checkpatch.pl


diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 451accd..6f56528 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -3158,31 +3158,30 @@ struct lpfc_sli2_slim {
  *
  * Parameters:
  * device : struct pci_dev 's device field
- *
- * return 1 => TRUE
- *        0 => FALSE
  */
-static inline int
+static inline bool
 lpfc_is_LC_HBA(unsigned short device)
 {
-	if ((device == PCI_DEVICE_ID_TFLY) ||
-	    (device == PCI_DEVICE_ID_PFLY) ||
-	    (device == PCI_DEVICE_ID_LP101) ||
-	    (device == PCI_DEVICE_ID_BMID) ||
-	    (device == PCI_DEVICE_ID_BSMB) ||
-	    (device == PCI_DEVICE_ID_ZMID) ||
-	    (device == PCI_DEVICE_ID_ZSMB) ||
-	    (device == PCI_DEVICE_ID_RFLY))
-		return 1;
-	else
-		return 0;
+	switch (device) {
+	case PCI_DEVICE_ID_TFLY:
+	case PCI_DEVICE_ID_PFLY:
+	case PCI_DEVICE_ID_LP101:
+	case PCI_DEVICE_ID_BMID:
+	case PCI_DEVICE_ID_BSMB:
+	case PCI_DEVICE_ID_ZMID:
+	case PCI_DEVICE_ID_ZSMB:
+	case PCI_DEVICE_ID_RFLY:
+		return true;
+	}
+
+	return false;
 }
 
 /*
  * Determine if an IOCB failed because of a link event or firmware reset.
  */
 
-static inline int
+static inline bool
 lpfc_error_lost_link(IOCB_t *iocbp)
 {
 	return (iocbp->ulpStatus == IOSTAT_LOCAL_REJECT &&

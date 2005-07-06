From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/17]  qla2xxx: Add pci ids for new ISP types.
Date: Wed,  6 Jul 2005 10:30:16 -0700 (PDT)
Message-ID: <20050706173016.10568.99101.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7503 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261670AbVGFRaV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:30:21 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add pci ids for new ISP types.

Move old definitions in local qla_def.h file to pci_ids.h as
well.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_def.h |   21 ---------------------
 include/linux/pci_ids.h        |    9 +++++++++
 2 files changed, 9 insertions(+), 21 deletions(-)

a74cc9d57ef985838b6fb9d07c3983e221d364d5
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -41,27 +41,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 
-/* XXX(hch): move to pci_ids.h */
-#ifndef PCI_DEVICE_ID_QLOGIC_ISP2300
-#define PCI_DEVICE_ID_QLOGIC_ISP2300	0x2300
-#endif
-
-#ifndef PCI_DEVICE_ID_QLOGIC_ISP2312
-#define PCI_DEVICE_ID_QLOGIC_ISP2312	0x2312
-#endif
-
-#ifndef PCI_DEVICE_ID_QLOGIC_ISP2322
-#define PCI_DEVICE_ID_QLOGIC_ISP2322	0x2322
-#endif
-
-#ifndef PCI_DEVICE_ID_QLOGIC_ISP6312
-#define PCI_DEVICE_ID_QLOGIC_ISP6312	0x6312
-#endif
-
-#ifndef PCI_DEVICE_ID_QLOGIC_ISP6322
-#define PCI_DEVICE_ID_QLOGIC_ISP6322	0x6322
-#endif
-
 #if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
 #define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
 #else
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -908,6 +908,15 @@
 #define PCI_DEVICE_ID_QLOGIC_ISP1022	0x1022
 #define PCI_DEVICE_ID_QLOGIC_ISP2100	0x2100
 #define PCI_DEVICE_ID_QLOGIC_ISP2200	0x2200
+#define PCI_DEVICE_ID_QLOGIC_ISP2300	0x2300
+#define PCI_DEVICE_ID_QLOGIC_ISP2312	0x2312
+#define PCI_DEVICE_ID_QLOGIC_ISP2322	0x2322
+#define PCI_DEVICE_ID_QLOGIC_ISP6312	0x6312
+#define PCI_DEVICE_ID_QLOGIC_ISP6322	0x6322
+#define PCI_DEVICE_ID_QLOGIC_ISP2422	0x2422
+#define PCI_DEVICE_ID_QLOGIC_ISP2432	0x2432
+#define PCI_DEVICE_ID_QLOGIC_ISP2512	0x2512
+#define PCI_DEVICE_ID_QLOGIC_ISP2522	0x2522
 
 #define PCI_VENDOR_ID_CYRIX		0x1078
 #define PCI_DEVICE_ID_CYRIX_5510	0x0000

-- 
Andrew Vasquez

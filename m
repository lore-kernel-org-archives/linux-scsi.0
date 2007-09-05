From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] aic94xx: Add new PCI ID for ASC58300
Date: Wed, 05 Sep 2007 16:04:29 -0700
Message-ID: <1189033469.6146.5.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:42709 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757151AbXIEVW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2007 17:22:58 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id A1F9D1F2356
	for <linux-scsi@vger.kernel.org>; Wed,  5 Sep 2007 14:22:57 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add new HBA PCI ID (0x416) for ASC58300 which has eight port SAS and
SATA PCI-X 133MHz low profile host bus adapter with two mini SAS 4x
external connectors.

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>


diff -urN a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-09-04 15:23:22.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-09-05 15:44:57.000000000 -0700
@@ -40,18 +40,6 @@
 #define ASD_MAX_PHYS       8
 #define ASD_PCBA_SN_SIZE   12
 
-/* Those are to be further named properly, the "RAZORx" part, and
- * subsequently included in include/linux/pci_ids.h.
- */
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR32 0x432
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR3E 0x43E
-#define PCI_DEVICE_ID_ADAPTEC2_RAZOR3F 0x43F
-
 struct asd_ha_addrspace {
 	void __iomem  *addr;
 	unsigned long  start;       /* pci resource start */
diff -urN a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	2007-09-04 15:23:14.000000000 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	2007-09-04 15:24:03.000000000 -0700
@@ -829,22 +829,15 @@
 };
 
 static const struct pci_device_id aic94xx_pci_table[] __devinitdata = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR10),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
-	 0, 0, 1},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR30),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR32),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR3E),
-	 0, 0, 2},
-	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR3F),
-	 0, 0, 2},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x410),0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x412),0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x416),0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x41E),0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x41F),0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x430),0, 0, 2},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x432),0, 0, 2},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x43E),0, 0, 2},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, 0x43F),0, 0, 2},
 	{}
 };
 

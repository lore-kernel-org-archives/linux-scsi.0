From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Add sereral new CCIN definitions for new adapters support
Date: Wed, 10 Jul 2013 10:46:27 -0500
Message-ID: <20130710154701.472259956@linux.vnet.ibm.com>
References: <20130710154626.020751207@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:44214 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754794Ab3GJQAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jul 2013 12:00:13 -0400
Content-Disposition: inline; filename=update_devid
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add the appropriate definitions and table entries for new adapter support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |   14 ++++++++++++++
 drivers/scsi/ipr.h |    7 +++++++
 2 files changed, 21 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-07-09 18:31:44.000000000 -0500
+++ b/drivers/scsi/ipr.c	2013-07-09 18:36:37.607965613 -0500
@@ -9990,6 +9990,20 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D7, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D8, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D9, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EB, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EC, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57ED, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EE, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EF, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57F0, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-07-09 18:31:48.000000000 -0500
+++ b/drivers/scsi/ipr.h	2013-07-09 18:34:49.107965920 -0500
@@ -100,6 +100,13 @@
 #define IPR_SUBS_DEV_ID_57D6    0x03FC
 #define IPR_SUBS_DEV_ID_57D7    0x03FF
 #define IPR_SUBS_DEV_ID_57D8    0x03FE
+#define IPR_SUBS_DEV_ID_57D9    0x046D
+#define IPR_SUBS_DEV_ID_57EB    0x0474
+#define IPR_SUBS_DEV_ID_57EC    0x0475
+#define IPR_SUBS_DEV_ID_57ED    0x0499
+#define IPR_SUBS_DEV_ID_57EE    0x049A
+#define IPR_SUBS_DEV_ID_57EF    0x049B
+#define IPR_SUBS_DEV_ID_57F0    0x049C
 #define IPR_NAME				"ipr"
 
 /*

-- 

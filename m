From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/7] RESEND ipr: Add sereral new CCIN definitions for new adapters support
Date: Mon, 03 Dec 2012 12:31:13 -0600
Message-ID: <20121203183211.818537028@linux.vnet.ibm.com>
References: <20121203183112.822371464@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:19072 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751376Ab2LCSe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 13:34:27 -0500
Content-Disposition: inline; filename=new_pciid
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add the appropriate definitions and table entries for new adapter support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   10 ++++++++++
 drivers/scsi/ipr.h |    5 +++++
 2 files changed, 15 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2012-11-14 20:15:46.666405044 -0600
+++ b/drivers/scsi/ipr.c	2012-11-14 20:23:26.295466065 -0600
@@ -9279,6 +9279,8 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C0, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
@@ -9292,6 +9294,14 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C8, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CE, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D5, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D6, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D7, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D8, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2012-11-14 20:15:46.666405044 -0600
+++ b/drivers/scsi/ipr.h	2012-11-14 20:23:23.404216172 -0600
@@ -82,6 +82,7 @@
 
 #define IPR_SUBS_DEV_ID_57B4    0x033B
 #define IPR_SUBS_DEV_ID_57B2    0x035F
+#define IPR_SUBS_DEV_ID_57C0    0x0352
 #define IPR_SUBS_DEV_ID_57C3    0x0353
 #define IPR_SUBS_DEV_ID_57C4    0x0354
 #define IPR_SUBS_DEV_ID_57C6    0x0357
@@ -94,6 +95,10 @@
 #define IPR_SUBS_DEV_ID_574D    0x0356
 #define IPR_SUBS_DEV_ID_57C8    0x035D
 
+#define IPR_SUBS_DEV_ID_57D5    0x03FB
+#define IPR_SUBS_DEV_ID_57D6    0x03FC
+#define IPR_SUBS_DEV_ID_57D7    0x03FF
+#define IPR_SUBS_DEV_ID_57D8    0x03FE
 #define IPR_NAME				"ipr"
 
 /*

-- 

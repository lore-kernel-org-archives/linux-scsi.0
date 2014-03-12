From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH RESEND 7/7] ipr: Add new CCIN definition for Grand Canyon support
Date: Wed, 12 Mar 2014 16:08:52 -0500
Message-ID: <20140312210906.781906662@vmlinux.vnet.ibm.com>
References: <20140312210845.384489953@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:29221 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752494AbaCLVMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:12:12 -0400
Content-Disposition: inline; filename=grand_canyon_id
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, bjking1@us.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add the appropriate definition and table entry for new hardware support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |    6 ++++++
 drivers/scsi/ipr.h |    3 +++
 2 files changed, 9 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-03-11 17:20:48.289943030 -0500
+++ b/drivers/scsi/ipr.c	2014-03-11 17:21:01.018707528 -0500
@@ -10123,6 +10123,12 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EF, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57F0, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCA, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CD2, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2CCD, 0, 0, 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2014-03-11 17:20:48.289943030 -0500
+++ b/drivers/scsi/ipr.h	2014-03-11 17:21:01.018707528 -0500
@@ -108,6 +108,9 @@
 #define IPR_SUBS_DEV_ID_57EE    0x049A
 #define IPR_SUBS_DEV_ID_57EF    0x049B
 #define IPR_SUBS_DEV_ID_57F0    0x049C
+#define IPR_SUBS_DEV_ID_2CCA	0x04C7
+#define IPR_SUBS_DEV_ID_2CD2	0x04C8
+#define IPR_SUBS_DEV_ID_2CCD	0x04C9
 #define IPR_NAME				"ipr"
 
 /*

-- 

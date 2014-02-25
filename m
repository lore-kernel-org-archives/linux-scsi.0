From: wenxiong@vmlinux.vnet.ibm.com
Subject: [PATCH 2/2] ipr: Add new CCIN definition for new hardware support
Date: Mon, 24 Feb 2014 19:18:00 -0600
Message-ID: <20140225011859.038850473@vmlinux.vnet.ibm.com>
References: <20140225011758.039512398@vmlinux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60278 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751489AbaBYBbD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 20:31:03 -0500
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
--- a/drivers/scsi/ipr.c	2014-02-24 18:12:49.618706961 -0600
+++ b/drivers/scsi/ipr.c	2014-02-24 18:14:04.059956190 -0600
@@ -10136,6 +10136,12 @@ static struct pci_device_id ipr_pci_tabl
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
--- a/drivers/scsi/ipr.h	2014-02-24 18:12:49.618706961 -0600
+++ b/drivers/scsi/ipr.h	2014-02-24 18:14:04.059956190 -0600
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

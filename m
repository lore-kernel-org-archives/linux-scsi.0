From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 2/3] ipr: Add new CCIN definition for new hardware support
Date: Tue, 21 Jan 2014 12:16:40 -0600
Message-ID: <20140121181746.563710677@linux.vnet.ibm.com>
References: <20140121181638.007394972@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60128 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754900AbaAUSaM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jan 2014 13:30:12 -0500
Content-Disposition: inline; filename=z06_ltd_devid
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

Add the appropriate definition and table entry for new hardware support.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |    2 ++
 drivers/scsi/ipr.h |    1 +
 2 files changed, 3 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2014-01-21 11:32:14.949015785 -0600
+++ b/drivers/scsi/ipr.c	2014-01-21 11:32:27.601198412 -0600
@@ -9998,6 +9998,8 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57D9, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57DA, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EB, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57EC, 0, 0, 0 },
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2014-01-21 11:32:14.957453279 -0600
+++ b/drivers/scsi/ipr.h	2014-01-21 11:32:27.601198412 -0600
@@ -101,6 +101,7 @@
 #define IPR_SUBS_DEV_ID_57D7    0x03FF
 #define IPR_SUBS_DEV_ID_57D8    0x03FE
 #define IPR_SUBS_DEV_ID_57D9    0x046D
+#define IPR_SUBS_DEV_ID_57DA    0x04CA
 #define IPR_SUBS_DEV_ID_57EB    0x0474
 #define IPR_SUBS_DEV_ID_57EC    0x0475
 #define IPR_SUBS_DEV_ID_57ED    0x0499

-- 

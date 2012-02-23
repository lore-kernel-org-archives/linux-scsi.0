From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: update PCI ID definitions for new adapters
Date: Thu, 23 Feb 2012 11:54:55 -0800
Message-ID: <4F46998F.3090806@linux.vnet.ibm.com>
References: <20120221181653.315237844@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010604090602000107060003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51226 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2BWTzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2012 14:55:17 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wayneb@linux.vnet.ibm.com>;
	Thu, 23 Feb 2012 12:55:15 -0700
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 5CEAB19D8061
	for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2012 12:55:04 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1NJswRA143390
	for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2012 12:54:58 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1NJsvsm030622
	for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2012 12:54:57 -0700
In-Reply-To: <20120221181653.315237844@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@br.ibm.com>

This is a multi-part message in MIME format.
--------------010604090602000107060003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch updates some PCI ID definitions for new adapters based on the next
generation 64 bit IOA PCI interface chip.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   14 +++++++-------
 drivers/scsi/ipr.h |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2012-02-20 20:02:13.710825979 -0800
+++ b/drivers/scsi/ipr.h	2012-02-21 09:16:44.662984899 -0800
@@ -58,7 +58,7 @@
 #define PCI_DEVICE_ID_IBM_OBSIDIAN_E	0x0339

 #define PCI_DEVICE_ID_IBM_CROC_FPGA_E2          0x033D
-#define PCI_DEVICE_ID_IBM_CROC_ASIC_E2          0x034A
+#define PCI_DEVICE_ID_IBM_CROCODILE             0x034A

 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
@@ -92,7 +92,7 @@
 #define IPR_SUBS_DEV_ID_57B1    0x0355

 #define IPR_SUBS_DEV_ID_574D    0x0356
-#define IPR_SUBS_DEV_ID_575D    0x035D
+#define IPR_SUBS_DEV_ID_57C8    0x035D

 #define IPR_NAME				"ipr"

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2012-02-20 20:02:12.550803227 -0800
+++ b/drivers/scsi/ipr.c	2012-02-21 09:19:33.230248907 -0800
@@ -183,7 +183,7 @@ static const struct ipr_chip_t ipr_chip[
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP, IPR_USE_LSI, IPR_SIS32, IPR_PCI_CFG, &ipr_chip_cfg[1] },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
 };

 static int ipr_max_bus_speeds [] = {
@@ -9179,15 +9179,15 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C6, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_575D, 0, 0, 0 },
-	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C8, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CE, 0, 0, 0 },
 	{ }
 };


--------------010604090602000107060003
Content-Type: text/plain;
 name="z28id"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="z28id"


--------------010604090602000107060003--


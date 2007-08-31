From: Gilbert Wu <Gilbert_Wu@adaptec.com>
Subject: [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
	driver to add new PCI ID for HBA ASC58300.
Date: Fri, 31 Aug 2007 10:59:49 -0700
Message-ID: <1188583189.6353.4.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:45095 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932946AbXHaSAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 14:00:21 -0400
Received: from aime2k302.adaptec.com (aime2k302.adaptec.com [10.25.8.48])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 25C1F190245
	for <linux-scsi@vger.kernel.org>; Fri, 31 Aug 2007 10:46:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Subject:  [PATCH] scsi: Update Aic94xx SAS/SATA Linux open source device
driver to add new PCI ID for HBA ASC58300.

Contribution:
   Gilbert Wu <gilbert_wu@adaptec.com>


Patch: apply to aic94xx-sas-2.6.git development tree

Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

Change Log:

1. Add new HBA PCI ID for ASC58300 which has eight port SAS and
   SATA PCI-X 133MHz low profile host bus adapter with two mini SAS
        4x external connectors. 



diff -urN old/drivers/scsi/aic94xx/aic94xx_hwi.h
new/drivers/scsi/aic94xx/aic94xx_hwi.h
--- old/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:21.000000000 -0700
+++ new/drivers/scsi/aic94xx/aic94xx_hwi.h	2007-08-30 16:34:02.000000000 -0700
@@ -45,6 +45,7 @@
  */
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
+#define PCI_DEVICE_ID_ADAPTEC2_RAZOR16 0x416
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
diff -urN old/drivers/scsi/aic94xx/aic94xx_init.c new/drivers/scsi/aic94xx/aic94xx_init.c
--- old/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:34:18.000000000 -0700
+++ new/drivers/scsi/aic94xx/aic94xx_init.c	2007-08-30 16:33:59.000000000 -0700
@@ -835,6 +835,8 @@
 	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR12),
 	 0, 0, 1},
+	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR16),
+	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
 	 0, 0, 1},
 	{PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),



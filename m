From: brking@us.ibm.com
Subject: [PATCH 01/15] PCI: update ipr PCI ids
Date: Mon, 21 Feb 2005 15:08:30 -0600
Message-ID: <200502212108.j1LL8USW008982@d01av03.pok.ibm.com>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:9627 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262116AbVBUVIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:08:37 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8aic026012
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:36 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL8a0H245520
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:36 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL8VaB009034
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:08:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Add some new IPR adapters and remove one. These ids have already been
entered into http://pciids.sourceforge.net.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/pci/pci.ids     |    7 +++++--
 linux-2.6.11-rc4-bk9-bjking1/include/linux/pci_ids.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/pci_ids.h~pci_ipr_update_ids include/linux/pci_ids.h
--- linux-2.6.11-rc4-bk9/include/linux/pci_ids.h~pci_ipr_update_ids	2005-02-21 14:49:08.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/include/linux/pci_ids.h	2005-02-21 14:49:08.000000000 -0600
@@ -2393,6 +2393,7 @@
 #define PCI_DEVICE_ID_ADAPTEC2_7899B	0x00c1
 #define PCI_DEVICE_ID_ADAPTEC2_7899D	0x00c3
 #define PCI_DEVICE_ID_ADAPTEC2_7899P	0x00cf
+#define PCI_DEVICE_ID_ADAPTEC2_SCAMP	0x0503
 
 #define PCI_VENDOR_ID_ATRONICS		0x907f
 #define PCI_DEVICE_ID_ATRONICS_2015	0x2015
diff -puN drivers/pci/pci.ids~pci_ipr_update_ids drivers/pci/pci.ids
--- linux-2.6.11-rc4-bk9/drivers/pci/pci.ids~pci_ipr_update_ids	2005-02-21 14:49:08.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/pci/pci.ids	2005-02-21 14:49:08.000000000 -0600
@@ -973,7 +973,6 @@
 	0180  Snipe chipset SCSI controller
 		1014 0241  iSeries 2757 DASD IOA
 		1014 0264  Quad Channel PCI-X U320 SCSI RAID Adapter (2780)
-		1014 02BD  Quad Channel PCI-X U320 DDR SCSI RAID Adapter (570F)
 	01a7  PCI-X to PCI-X Bridge
 	01bd  ServeRAID Controller
 		1014 01be  ServeRAID-4M
@@ -997,7 +996,9 @@
 	0268  Gigabit Ethernet-SX Adapter (PCI-X)
 	0269  10/100/1000 Base-TX Ethernet Adapter (PCI-X)
 	028C  Citrine chipset SCSI controller
-		1014 02BE  Dual Channel PCI-X U320 DDR SCSI RAID Adapter (571B)
+		1014 028D  Dual Channel PCI-X DDR SAS RAID Adapter (572E)
+		1014 02BE  Dual Channel PCI-X DDR U320 SCSI RAID Adapter (571B)
+		1014 02C0  Dual Channel PCI-X DDR U320 SCSI Adapter (571A)
 	0302  X-Architecture Bridge [Summit]
 	ffff  MPIC-2 interrupt controller
 1015  LSI Logic Corp of Canada
@@ -8647,6 +8648,8 @@
 		9005 0294  ESD SO-DIMM PCI-X SATA ZCR (Prowler)
 	0286  AAC-RAID (Rocket)
 		9005 028c  ASR-2230S + ASR-2230SLP PCI-X (Lancer)
+	0503  Scamp chipset SCSI controller
+		1014 02BF  Quad Channel PCI-X DDR U320 SCSI RAID Adapter (571E)
 	8000  ASC-29320A U320
 	800f  AIC-7901 U320
 	8010  ASC-39320 U320
_

From: brking@us.ibm.com
Subject: [PATCH 01/16] ipr: New PCI IDs
Date: Wed, 04 Aug 2004 17:31:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042231.i74MVXoo334442@westrelay02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:36770 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S267466AbUHDWbg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2004 18:31:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Add a couple new devices supported by the ipr device driver. This patch
has already been sent to pciids-devel@lists.sourceforge.net.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/pci/pci.ids     |    5 +++++
 linux-2.6.8-rc3-bjking1/include/linux/pci_ids.h |    1 +
 2 files changed, 6 insertions(+)

diff -puN include/linux/pci_ids.h~ipr_new_pci_ids include/linux/pci_ids.h
--- linux-2.6.8-rc3/include/linux/pci_ids.h~ipr_new_pci_ids	2004-08-04 09:57:34.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/include/linux/pci_ids.h	2004-08-04 09:57:34.000000000 -0500
@@ -438,6 +438,7 @@
 #define	PCI_DEVICE_ID_IBM_405GP		0x0156
 #define PCI_DEVICE_ID_IBM_SNIPE		0x0180
 #define PCI_DEVICE_ID_IBM_SERVERAIDI960	0x01bd
+#define PCI_DEVICE_ID_IBM_CITRINE		0x028C
 #define PCI_DEVICE_ID_IBM_GEMSTONE		0xB166
 #define PCI_DEVICE_ID_IBM_MPIC_2	0xffff
 
diff -puN drivers/pci/pci.ids~ipr_new_pci_ids drivers/pci/pci.ids
--- linux-2.6.8-rc3/drivers/pci/pci.ids~ipr_new_pci_ids	2004-08-04 09:57:34.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/pci/pci.ids	2004-08-04 09:57:34.000000000 -0500
@@ -924,6 +924,7 @@
 	0180  Snipe chipset SCSI controller
 		1014 0241  iSeries 2757 DASD IOA
 		1014 0264  Quad Channel PCI-X U320 SCSI RAID Adapter (2780)
+		1014 02BD  Quad Channel PCI-X U320 DDR SCSI RAID Adapter (570F)
 	01a7  PCI-X to PCI-X Bridge
 	01bd  ServeRAID Controller
 		1014 01be  ServeRAID-4M
@@ -946,6 +947,8 @@
 	0266  PCI-X Dual Channel SCSI
 	0268  Gigabit Ethernet-SX Adapter (PCI-X)
 	0269  10/100/1000 Base-TX Ethernet Adapter (PCI-X)
+	028C  Citrine chipset SCSI controller
+		1014 02BE  Dual Channel PCI-X U320 DDR SCSI RAID Adapter (571B)
 	0302  XA-32 chipset [Summit]
 	ffff  MPIC-2 interrupt controller
 1015  LSI Logic Corp of Canada
@@ -2070,6 +2073,8 @@
 		1014 0242  iSeries 2872 DASD IOA
 		1014 0266  Dual Channel PCI-X U320 SCSI Adapter
 		1014 0278  Dual Channel PCI-X U320 SCSI RAID Adapter
+		1014 02D3  Dual Channel PCI-X U320 SCSI Adapter
+		1014 02D4  Dual Channel PCI-X U320 SCSI RAID Adapter
 	ba55  eXtremeRAID 1100 support Device
 	ba56  eXtremeRAID 2000/3000 support Device
 106a  Aten Research Inc
_

From: brking@us.ibm.com
Subject: [PATCH 22/26] pci: PCI ids for new ipr adapters
Date: Tue, 01 Nov 2005 17:02:36 -0600
Message-ID: <200511012302.jA1N2aC3018391@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57552 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751419AbVKAXCi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:38 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2cTe018281
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:38 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2bbn116998
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:37 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N2bgA018416
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds some new PCI IDs for new IPR adapters.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/include/linux/pci_ids.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/linux/pci_ids.h~pci_ipr_sas_ids include/linux/pci_ids.h
--- linux-2.6/include/linux/pci_ids.h~pci_ipr_sas_ids	2005-11-01 16:54:23.000000000 -0600
+++ linux-2.6-bjking1/include/linux/pci_ids.h	2005-11-01 16:54:23.000000000 -0600
@@ -441,6 +441,7 @@
 #define PCI_DEVICE_ID_IBM_SNIPE		0x0180
 #define PCI_DEVICE_ID_IBM_CITRINE		0x028C
 #define PCI_DEVICE_ID_IBM_GEMSTONE		0xB166
+#define PCI_DEVICE_ID_IBM_OBSIDIAN		0x02BD
 #define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_1	0x0031
 #define PCI_DEVICE_ID_IBM_ICOM_DEV_ID_2	0x0219
 #define PCI_DEVICE_ID_IBM_ICOM_V2_TWO_PORTS_RVX		0x021A
@@ -2137,6 +2138,7 @@
 #define PCI_DEVICE_ID_ADAPTEC2_7899B	0x00c1
 #define PCI_DEVICE_ID_ADAPTEC2_7899D	0x00c3
 #define PCI_DEVICE_ID_ADAPTEC2_7899P	0x00cf
+#define PCI_DEVICE_ID_ADAPTEC2_OBSIDIAN   0x0500
 #define PCI_DEVICE_ID_ADAPTEC2_SCAMP	0x0503
 
 
_

From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: pci.ids patch re-issued inline rather than as an attachment.
Date: Tue, 11 Jan 2005 11:24:46 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B9BA0CD@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43412 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262808AbVAKQYs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 11:24:48 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pci-ids@ucw.cz
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi@vger.kernel.org

This patch synchronizes pci.ids with the new products in the aacraid
driver.

Signed-off-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

diff -u --recursive linux-2.6.10-rc3-bk14/drivers/pci/pci.ids
linux-2.6.10-new/drivers/pci/pci.ids
--- linux-2.6.10-rc3-bk14/drivers/pci/pci.ids	Tue Nov 30 07:44:21 2004
+++ linux-2.6.10-new/drivers/pci/pci.ids	Tue Jan 11 07:27:04 2005
@@ -8630,6 +8630,8 @@
 		0e11 0295  SATA 6Ch (Bearcat)
 		1028 0287  PowerEdge Expandable RAID Controller 320/DC
 		1028 0291  CERC SATA RAID 2 PCI SATA 6ch (DellCorsair)
+		103C 3227  AAR-2610SA
+		1014 02f2  ServeRAID 8i
 		17aa 0286  Legend S220 (Legend Crusader)
 		17aa 0287  Legend S230 (Legend Vulcan)
 		9005 0285  2200S (Vulcan)
@@ -8639,12 +8641,25 @@
 		9005 0289  3240S (Tornado)
 		9005 028a  ASR-2020S PCI-X ZCR (Skyhawk)
 		9005 028b  ASR-2020S SO-DIMM PCI-X ZCR (Terminator)
+		9005 028f  ASR-2025SA
 		9005 0290  AAR-2410SA PCI SATA 4ch (Jaguar II)
 		9005 0292  AAR-2810SA PCI SATA 8ch (Corsair-8)
 		9005 0293  AAR-21610SA PCI SATA 16ch (Corsair-16)
 		9005 0294  ESD SO-DIMM PCI-X SATA ZCR (Prowler)
+		9005 0296  ASR-2240S
+		9005 0297  ASR-4005SAS
+		9005 0298  ASR-4000SAS
+		9005 0299  ASR-4800SAS
+		9005 029a  ASR-4805SAS
 	0286  AAC-RAID (Rocket)
 		9005 028c  ASR-2230S + ASR-2230SLP PCI-X (Lancer)
+		9005 028d  ASR-2130S
+		9005 029b  ASR-2820SA
+		9005 029c  ASR-2620SA
+		9005 029d  ASR-2420SA
+		9005 029e  ICP9024R0
+		9005 029f  ICP9014R0
+		9005 0800  Callisto
 	8000  ASC-29320A U320
 	800f  AIC-7901 U320
 	8010  ASC-39320 U320

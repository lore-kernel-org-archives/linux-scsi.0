From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: adapter support update
Date: Mon, 08 Aug 2005 14:20:43 -0700
Message-ID: <1123536043.3927.4.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35026 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932261AbVHHVUu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 17:20:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn

This patch adds the product ID for the ICP9067MA adapter.

The entries for the ICP9085LI, ICP5085BR, IBM8k & ASR4810SAS were
incorrect and would not initialize the adapters correctly.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>


Index: scsi-misc-aac-1/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/linit.c	2005-08-08 09:11:56.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/linit.c	2005-08-08 11:04:51.000000000 -0700
@@ -120,36 +120,39 @@
 	{ 0x9005, 0x0286, 0x9005, 0x02a3, 0, 0, 29 }, /* ICP5085AU (Hurricane) */
 	{ 0x9005, 0x0285, 0x9005, 0x02a4, 0, 0, 30 }, /* ICP9085LI (Marauder-X) */
 	{ 0x9005, 0x0285, 0x9005, 0x02a5, 0, 0, 31 }, /* ICP5085BR (Marauder-E) */
-	{ 0x9005, 0x0287, 0x9005, 0x0800, 0, 0, 32 }, /* Themisto Jupiter Platform */
-	{ 0x9005, 0x0200, 0x9005, 0x0200, 0, 0, 32 }, /* Themisto Jupiter Platform */
-	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 33 }, /* Callisto Jupiter Platform */
-	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 34 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
-	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 35 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
-	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 36 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
-	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 37 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
-	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 38 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
-	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 39 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
-	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 40 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
-	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 41 }, /* AAR-2610SA PCI SATA 6ch */
-	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 42 }, /* ASR-2240S (SabreExpress) */
-	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 43 }, /* ASR-4005SAS */
-	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 44 }, /* IBM 8i (AvonPark) */
-	{ 0x9005, 0x0285, 0x1014, 0x0312, 0, 0, 44 }, /* IBM 8i (AvonPark Lite) */
-	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 45 }, /* ASR-4000SAS (BlackBird) */
-	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 46 }, /* ASR-4800SAS (Marauder-X) */
-	{ 0x9005, 0x0285, 0x9005, 0x029a, 0, 0, 47 }, /* ASR-4805SAS (Marauder-E) */
-	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 48 }, /* ASR-4810SAS (Hurricane */
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 49 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 50 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 51 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 52 }, /* Dell PERC2/QC */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 53 }, /* HP NetRAID-4M */
-
-	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 54 }, /* Dell Catchall */
-	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 55 }, /* Legend Catchall */
-	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 56 }, /* Adaptec Catch All */
-	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 57 }, /* Adaptec Rocket Catch All */
+	{ 0x9005, 0x0286, 0x9005, 0x02a6, 0, 0, 32 }, /* ICP9067MA (Intruder-6) */
+	{ 0x9005, 0x0287, 0x9005, 0x0800, 0, 0, 33 }, /* Themisto Jupiter Platform */
+	{ 0x9005, 0x0200, 0x9005, 0x0200, 0, 0, 33 }, /* Themisto Jupiter Platform */
+	{ 0x9005, 0x0286, 0x9005, 0x0800, 0, 0, 34 }, /* Callisto Jupiter Platform */
+	{ 0x9005, 0x0285, 0x9005, 0x028e, 0, 0, 35 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
+	{ 0x9005, 0x0285, 0x9005, 0x028f, 0, 0, 36 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
+	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 37 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ 0x9005, 0x0285, 0x1028, 0x0291, 0, 0, 38 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ 0x9005, 0x0285, 0x9005, 0x0292, 0, 0, 39 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ 0x9005, 0x0285, 0x9005, 0x0293, 0, 0, 40 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ 0x9005, 0x0285, 0x9005, 0x0294, 0, 0, 41 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
+	{ 0x9005, 0x0285, 0x103C, 0x3227, 0, 0, 42 }, /* AAR-2610SA PCI SATA 6ch */
+	{ 0x9005, 0x0285, 0x9005, 0x0296, 0, 0, 43 }, /* ASR-2240S (SabreExpress) */
+	{ 0x9005, 0x0285, 0x9005, 0x0297, 0, 0, 44 }, /* ASR-4005SAS */
+	{ 0x9005, 0x0285, 0x1014, 0x02F2, 0, 0, 45 }, /* IBM 8i (AvonPark) */
+	{ 0x9005, 0x0285, 0x1014, 0x0312, 0, 0, 45 }, /* IBM 8i (AvonPark Lite) */
+	{ 0x9005, 0x0286, 0x1014, 0x9580, 0, 0, 46 }, /* IBM 8k/8k-l8 (Aurora) */
+	{ 0x9005, 0x0286, 0x1014, 0x9540, 0, 0, 47 }, /* IBM 8k/8k-l4 (Aurora Lite) */
+	{ 0x9005, 0x0285, 0x9005, 0x0298, 0, 0, 48 }, /* ASR-4000SAS (BlackBird) */
+	{ 0x9005, 0x0285, 0x9005, 0x0299, 0, 0, 49 }, /* ASR-4800SAS (Marauder-X) */
+	{ 0x9005, 0x0285, 0x9005, 0x029a, 0, 0, 50 }, /* ASR-4805SAS (Marauder-E) */
+	{ 0x9005, 0x0286, 0x9005, 0x02a2, 0, 0, 51 }, /* ASR-4810SAS (Hurricane */
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 52 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 53 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 54 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 55 }, /* Dell PERC2/QC */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 56 }, /* HP NetRAID-4M */
+
+	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 57 }, /* Dell Catchall */
+	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 58 }, /* Legend Catchall */
+	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec Catch All */
+	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec Rocket Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -191,8 +194,9 @@
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9047MA       ", 1 }, /* ICP9047MA (Lancer) */
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9087MA       ", 1 }, /* ICP9087MA (Lancer) */
 	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5085AU       ", 1 }, /* ICP5085AU (Hurricane) */
-	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9085LI       ", 1 }, /* ICP9085LI (Marauder-X) */
-	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP5085BR       ", 1 }, /* ICP5085BR (Marauder-E) */
+	{ aac_rx_init, "aacraid",  "ICP     ", "ICP9085LI       ", 1 }, /* ICP9085LI (Marauder-X) */
+	{ aac_rx_init, "aacraid",  "ICP     ", "ICP5085BR       ", 1 }, /* ICP5085BR (Marauder-E) */
+	{ aac_rkt_init, "aacraid",  "ICP     ", "ICP9067MA       ", 1 }, /* ICP9067MA (Intruder-6) */
 	{ NULL        , "aacraid",  "ADAPTEC ", "Themisto        ", 0, AAC_QUIRK_SLAVE }, /* Jupiter Platform */
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2, AAC_QUIRK_MASTER }, /* Jupiter Platform */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA       ", 1 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
@@ -206,10 +210,12 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S (SabreExpress) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4005SAS     ", 1 }, /* ASR-4005SAS */
 	{ aac_rx_init, "ServeRAID","IBM     ", "ServeRAID 8i    ", 1 }, /* IBM 8i (AvonPark) */
+	{ aac_rkt_init, "ServeRAID","IBM     ", "ServeRAID 8k-l8 ", 1 }, /* IBM 8k/8k-l8 (Aurora) */
+	{ aac_rkt_init, "ServeRAID","IBM     ", "ServeRAID 8k-l4 ", 1 }, /* IBM 8k/8k-l4 (Aurora Lite) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4000SAS     ", 1 }, /* ASR-4000SAS (BlackBird & AvonPark) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4800SAS     ", 1 }, /* ASR-4800SAS (Marauder-X) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4805SAS     ", 1 }, /* ASR-4805SAS (Marauder-E) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-4810SAS     ", 1 }, /* ASR-4810SAS (Hurricane) */
+	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "ASR-4810SAS     ", 1 }, /* ASR-4810SAS (Hurricane) */
 
 	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG }, /* Perc 320/DC*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4, AAC_QUIRK_34SG }, /* Adaptec 5400S (Mustang)*/

-- 
Mark Haverkamp <markh@osdl.org>


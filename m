From: James Smart <james.smart@emulex.com>
Subject: [PATCH V2 3/5] lpfc 10.2.8001.0: Removed obsolete PCI IDs from the
 driver.
Date: Wed, 21 May 2014 08:05:19 -0400
Message-ID: <1400673919.16422.9.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4918 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaEUMFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 08:05:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reworked per Christoph's suggestions.

--

Removed obsolete PCI IDs from the driver.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   83 +++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 34 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-05-20 20:14:21.990332318 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-05-20 20:14:43.772331499 -0400
@@ -2033,78 +2033,81 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 
 	switch (dev_id) {
 	case PCI_DEVICE_ID_FIREFLY:
-		m = (typeof(m)){"LP6000", "PCI", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP6000", "PCI",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SUPERFLY:
 		if (vp->rev.biuRev >= 1 && vp->rev.biuRev <= 3)
-			m = (typeof(m)){"LP7000", "PCI",
-					"Fibre Channel Adapter"};
+			m = (typeof(m)){"LP7000", "PCI", ""};
 		else
-			m = (typeof(m)){"LP7000E", "PCI",
-					"Fibre Channel Adapter"};
+			m = (typeof(m)){"LP7000E", "PCI", ""};
+		m.function = "Obsolete, Unsupported Fibre Channel Adapter";
 		break;
 	case PCI_DEVICE_ID_DRAGONFLY:
 		m = (typeof(m)){"LP8000", "PCI",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_CENTAUR:
 		if (FC_JEDEC_ID(vp->rev.biuRev) == CENTAUR_2G_JEDEC_ID)
-			m = (typeof(m)){"LP9002", "PCI",
-					"Fibre Channel Adapter"};
+			m = (typeof(m)){"LP9002", "PCI", ""};
 		else
-			m = (typeof(m)){"LP9000", "PCI",
-					"Fibre Channel Adapter"};
+			m = (typeof(m)){"LP9000", "PCI", ""};
+		m.function = "Obsolete, Unsupported Fibre Channel Adapter";
 		break;
 	case PCI_DEVICE_ID_RFLY:
 		m = (typeof(m)){"LP952", "PCI",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PEGASUS:
 		m = (typeof(m)){"LP9802", "PCI-X",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_THOR:
 		m = (typeof(m)){"LP10000", "PCI-X",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_VIPER:
 		m = (typeof(m)){"LPX1000",  "PCI-X",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PFLY:
 		m = (typeof(m)){"LP982", "PCI-X",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_TFLY:
 		m = (typeof(m)){"LP1050", "PCI-X",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS:
 		m = (typeof(m)){"LP11000", "PCI-X2",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_SCSP:
 		m = (typeof(m)){"LP11000-SP", "PCI-X2",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HELIOS_DCSP:
 		m = (typeof(m)){"LP11002-SP",  "PCI-X2",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE:
-		m = (typeof(m)){"LPe1000", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe1000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_SCSP:
-		m = (typeof(m)){"LPe1000-SP", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe1000-SP", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_NEPTUNE_DCSP:
-		m = (typeof(m)){"LPe1002-SP", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe1002-SP", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BMID:
 		m = (typeof(m)){"LP1150", "PCI-X2", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_BSMB:
-		m = (typeof(m)){"LP111", "PCI-X2", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP111", "PCI-X2",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_ZEPHYR:
 		m = (typeof(m)){"LPe11000", "PCIe", "Fibre Channel Adapter"};
@@ -2123,16 +2126,20 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		m = (typeof(m)){"LPe111", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP101:
-		m = (typeof(m)){"LP101", "PCI-X", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP101", "PCI-X",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP10000S:
-		m = (typeof(m)){"LP10000-S", "PCI", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP10000-S", "PCI",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LP11000S:
-		m = (typeof(m)){"LP11000-S", "PCI-X2", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LP11000-S", "PCI-X2",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LPE11000S:
-		m = (typeof(m)){"LPe11000-S", "PCIe", "Fibre Channel Adapter"};
+		m = (typeof(m)){"LPe11000-S", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_SAT:
 		m = (typeof(m)){"LPe12000", "PCIe", "Fibre Channel Adapter"};
@@ -2153,20 +2160,21 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		m = (typeof(m)){"LPe12000-S", "PCIe", "Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_HORNET:
-		m = (typeof(m)){"LP21000", "PCIe", "FCoE Adapter"};
+		m = (typeof(m)){"LP21000", "PCIe",
+				"Obsolete, Unsupported FCoE Adapter"};
 		GE = 1;
 		break;
 	case PCI_DEVICE_ID_PROTEUS_VF:
 		m = (typeof(m)){"LPev12000", "PCIe IOV",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PROTEUS_PF:
 		m = (typeof(m)){"LPev12000", "PCIe IOV",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_PROTEUS_S:
 		m = (typeof(m)){"LPemv12002-S", "PCIe IOV",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_TIGERSHARK:
 		oneConnect = 1;
@@ -2182,17 +2190,24 @@ lpfc_get_hba_model_desc(struct lpfc_hba
 		break;
 	case PCI_DEVICE_ID_BALIUS:
 		m = (typeof(m)){"LPVe12002", "PCIe Shared I/O",
-				"Fibre Channel Adapter"};
+				"Obsolete, Unsupported Fibre Channel Adapter"};
 		break;
 	case PCI_DEVICE_ID_LANCER_FC:
-	case PCI_DEVICE_ID_LANCER_FC_VF:
 		m = (typeof(m)){"LPe16000", "PCIe", "Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_FC_VF:
+		m = (typeof(m)){"LPe16000", "PCIe",
+				"Obsolete, Unsupported Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_LANCER_FCOE:
-	case PCI_DEVICE_ID_LANCER_FCOE_VF:
 		oneConnect = 1;
 		m = (typeof(m)){"OCe15100", "PCIe", "FCoE"};
 		break;
+	case PCI_DEVICE_ID_LANCER_FCOE_VF:
+		oneConnect = 1;
+		m = (typeof(m)){"OCe15100", "PCIe",
+				"Obsolete, Unsupported FCoE"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;



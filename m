From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/15] qla2xxx: Use PCI_DEVICE() for pci_device_id definition.
Date: Wed, 17 May 2006 15:09:39 -0700
Message-ID: <11479037742602-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:955 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751225AbWEQWJl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:41 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

13305ab3c5a520fd41d855ddec1b69527ec9c6a8
 drivers/scsi/qla2xxx/qla_os.c |   33 +++++++++++----------------------
 1 files changed, 11 insertions(+), 22 deletions(-)

13305ab3c5a520fd41d855ddec1b69527ec9c6a8
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 174b04a..f1525dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2606,28 +2606,17 @@ qla2x00_release_firmware(void)
 }
 
 static struct pci_device_id qla2xxx_pci_tbl[] = {
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2300,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2312,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2322,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6312,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6322,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2422,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2432,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5422,
-		PCI_ANY_ID, PCI_ANY_ID, },
-	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432,
-		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2300) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2322) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6322) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2422) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2432) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5422) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
-- 
1.3.3.g63df



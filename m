From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 6/7] smartpqi: add in new controller ids
Date: Thu, 10 Aug 2017 13:47:09 -0500
Message-ID: <150239082948.23771.16460697160530748226.stgit@brunhilda>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0041.outbound.protection.outlook.com ([104.47.38.41]:56725
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753122AbdHJSr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 14:47:29 -0400
In-Reply-To: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Update the driver’s PCI IDs to match the latest
Microsemi controllers

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   36 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index afd3eed..59b6301 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6822,7 +6822,7 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0605)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0608)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
@@ -6854,6 +6854,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0807)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x0900)
 	},
 	{
@@ -6890,6 +6894,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x090a)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1200)
 	},
 	{
@@ -6922,6 +6930,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_DELL, 0x1fe0)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x0600)
 	},
 	{
@@ -6938,11 +6950,7 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0604)
-	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0606)
+			       PCI_VENDOR_ID_HP, 0x0609)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
@@ -6970,14 +6978,6 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0656)
-	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0657)
-	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x0700)
 	},
 	{
@@ -6998,14 +6998,6 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x1102)
-	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x1150)
-	},
-	{
-		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
 	},
 	{ 0 }

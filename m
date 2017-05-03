From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 16/36] smartpqi: add new PCI device IDs
Date: Wed, 3 May 2017 18:53:54 -0500
Message-ID: <149385563436.11043.4532840713249628491.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0087.outbound.protection.outlook.com ([104.47.37.87]:60097
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751391AbdECXx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:53:59 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  134 +++++++++++++++++++++++++++------
 1 file changed, 109 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 91daedc..6b20a91 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6390,107 +6390,191 @@ static int pqi_resume(struct pci_dev *pci_dev)
 static const struct pci_device_id pqi_pci_id_table[] = {
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x152d, 0x8a22)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x152d, 0x8a23)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x152d, 0x8a24)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x152d, 0x8a36)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x152d, 0x8a37)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x0110)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0600)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0605)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0601)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0800)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0602)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0801)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0603)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0802)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0650)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0803)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0651)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0804)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0652)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0805)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0653)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0806)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0654)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0900)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0655)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0901)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0700)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0902)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_HP, 0x0701)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0903)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0800)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0904)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0801)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0905)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0802)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0906)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0803)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0907)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0804)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x0908)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0805)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1200)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0900)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1201)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0901)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1202)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0902)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1280)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0903)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1281)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0904)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1300)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0905)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1301)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
-			       PCI_VENDOR_ID_ADAPTEC2, 0x0906)
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1380)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0600)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0601)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0602)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0603)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0604)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0606)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0650)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0651)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0652)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0653)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0654)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0655)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0656)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0657)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0700)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_HP, 0x0701)
 	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,

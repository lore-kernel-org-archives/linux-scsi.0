From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V1 2/2] aacraid: remove wildcard for series 9 controllers
Date: Wed, 8 Jun 2016 20:19:46 -0500
Message-ID: <146543518615.10204.15870006831854865012.stgit@brunhilda>
References: <146543503567.10204.3458324982970458038.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:47776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751172AbcFIBUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jun 2016 21:20:22 -0400
In-Reply-To: <146543503567.10204.3458324982970458038.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Depends on smartpqi driver adoption

Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/aacraid/linit.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 79871f3..d5b26fa 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -160,7 +160,6 @@ static const struct pci_device_id aac_pci_tbl[] = {
 	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec PMC Series 6 (Tupelo) */
 	{ 0x9005, 0x028c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 63 }, /* Adaptec PMC Series 7 (Denali) */
 	{ 0x9005, 0x028d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 64 }, /* Adaptec PMC Series 8 */
-	{ 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec PMC Series 9 */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -239,7 +238,6 @@ static struct aac_driver_ident aac_drivers[] = {
 	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 6 (Tupelo) */
 	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 7 (Denali) */
 	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 8 */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC } /* Adaptec PMC Series 9 */
 };
 
 /**


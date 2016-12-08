From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] aacraid: remove wildcard for series 9 controllers
Date: Thu, 8 Dec 2016 10:29:29 -0600
Message-ID: <148121456881.26136.5279334565466197341.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:15584
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932787AbcLHQaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 11:30:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Depends on smartpqi driver adoption

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
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


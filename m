From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH] qedi: Add PCI device-ID for QL41xxx adapters.
Date: Wed, 15 Mar 2017 01:32:53 -0700
Message-ID: <20170315083253.6721-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:18304
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751416AbdCOIdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 04:33:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 8e3d928..92775a8 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2007,6 +2007,7 @@ static void qedi_remove(struct pci_dev *pdev)
 
 static struct pci_device_id qedi_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x165E) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x8084) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qedi_pci_tbl);
-- 
1.8.3.1

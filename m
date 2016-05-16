From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH 2/2] ufs: driver changed to avoid name collision with Samsung's
Date: Mon, 16 May 2016 19:59:02 +0100
Message-ID: <b4581096a23a4853c8c7137718eb4337e619354d.1463424861.git.jpinto@synopsys.com>
References: <cover.1463424861.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:56020 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbcEPS7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2016 14:59:14 -0400
In-Reply-To: <cover.1463424861.git.jpinto@synopsys.com>
In-Reply-To: <cover.1463424861.git.jpinto@synopsys.com>
References: <cover.1463424861.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

This patch changes the tc-dwc-g210-pci driver's name to avoid name collisions
with the Smsung's driver.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 drivers/scsi/ufs/tc-dwc-g210-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pci.c b/drivers/scsi/ufs/tc-dwc-g210-pci.c
index 0667c76..c09a0fe 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pci.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pci.c
@@ -164,7 +164,7 @@ static const struct pci_device_id tc_dwc_g210_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, tc_dwc_g210_pci_tbl);
 
 static struct pci_driver tc_dwc_g210_pci_driver = {
-	.name = UFSHCD,
+	.name = "tc-dwc-g210-pci",
 	.id_table = tc_dwc_g210_pci_tbl,
 	.probe = tc_dwc_g210_pci_probe,
 	.remove = tc_dwc_g210_pci_remove,
-- 
1.8.1.5


From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 3/4] esas2r: Remove superfluous mask of pcie_cap_reg
Date: Tue, 1 Oct 2013 14:26:03 -0400
Message-ID: <1380651964-8124-3-git-send-email-bgrove@attotech.com>
References: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:51974 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440Ab3JASf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 14:35:26 -0400
In-Reply-To: <1380651964-8124-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, Bradley Grove <bgrove@attotech.com>

Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 8278819..b9750e2 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -807,7 +807,7 @@ static void esas2r_init_pci_cfg_space(struct esas2r_adapter *a)
 	int pcie_cap_reg;
 
 	pcie_cap_reg = pci_find_capability(a->pcid, PCI_CAP_ID_EXP);
-	if (0xffff & pcie_cap_reg) {
+	if (pcie_cap_reg) {
 		u16 devcontrol;
 
 		pci_read_config_word(a->pcid, pcie_cap_reg + PCI_EXP_DEVCTL,
-- 
1.8.3.1


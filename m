From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH 1/6] SCSI: esas2r: smatch - Use biwise rather than logical AND for checking if any bit set
Date: Thu, 29 Aug 2013 15:55:39 -0400
Message-ID: <1377806144-4902-2-git-send-email-bgrove@attotech.com>
References: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:14574 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756042Ab3H2Uny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 16:43:54 -0400
In-Reply-To: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 3a798e7..78b18c1 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -808,7 +808,7 @@ static void esas2r_init_pci_cfg_space(struct esas2r_adapter *a)
 	int pcie_cap_reg;
 
 	pcie_cap_reg = pci_find_capability(a->pcid, PCI_CAP_ID_EXP);
-	if (0xffff && pcie_cap_reg) {
+	if (0xffff & pcie_cap_reg) {
 		u16 devcontrol;
 
 		pci_read_config_word(a->pcid, pcie_cap_reg + PCI_EXP_DEVCTL,
-- 
1.8.1.4


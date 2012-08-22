From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 32/42] qla2xxx: Set Maximum Read Request Size to 4K.
Date: Wed, 22 Aug 2012 14:21:26 -0400
Message-ID: <1345659696-3670-33-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:45573 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965008Ab2HVSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:36 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2b9b750..b46ff87 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -767,7 +767,7 @@ qla24xx_pci_config(scsi_qla_host_t *vha)
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
 	if (pci_is_pcie(ha->pdev))
-		pcie_set_readrq(ha->pdev, 2048);
+		pcie_set_readrq(ha->pdev, 4096);
 
 	pci_disable_rom(ha->pdev);
 
@@ -803,7 +803,7 @@ qla25xx_pci_config(scsi_qla_host_t *vha)
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
 	if (pci_is_pcie(ha->pdev))
-		pcie_set_readrq(ha->pdev, 2048);
+		pcie_set_readrq(ha->pdev, 4096);
 
 	pci_disable_rom(ha->pdev);
 
-- 
1.7.7


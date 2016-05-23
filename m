From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] ufs: Adding license info do tc-dwc-g210 and ufshcd-dwc to enable loadable modules
Date: Mon, 23 May 2016 10:18:07 +0100
Message-ID: <a22c319eb110d08adea99657cf5f1cfd491d6c7e.1463994992.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:50454 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbcEWJSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2016 05:18:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

This patch adds license info to the tc-dwc-g210 and ufshcd-dwc files in
order for them to have access to some ufshcd symbols when all are built
as modules.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 drivers/scsi/ufs/tc-dwc-g210.c | 4 ++++
 drivers/scsi/ufs/ufshcd-dwc.c  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index 181f208..d6c5388 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -313,3 +313,7 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(tc_dwc_g210_config_20_bit);
+
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_DESCRIPTION("Synopsys G210 Test Chip driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
index 9b3ca7f..5fd16c7 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -148,3 +148,7 @@ out:
 	return err;
 }
 EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
+
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_DESCRIPTION("UFS Host driver for Synopsys Designware Core");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.8.1.5


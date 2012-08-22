From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 40/42] qla2xxx: Allow MSI interrupt registration for ISP82xx.
Date: Wed, 22 Aug 2012 14:21:34 -0400
Message-ID: <1345659696-3670-41-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:58992 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965017Ab2HVSih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:37 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2349d2e..5733811 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2918,7 +2918,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 skip_msix:
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
-	    !IS_QLA8001(ha))
+	    !IS_QLA8001(ha) && !IS_QLA82XX(ha))
 		goto skip_msi;
 
 	ret = pci_enable_msi(ha->pdev);
-- 
1.7.7


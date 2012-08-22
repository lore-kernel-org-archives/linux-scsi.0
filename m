From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 41/42] qla2xxx: Use the right field for container_of.
Date: Wed, 22 Aug 2012 14:21:35 -0400
Message-ID: <1345659696-3670-42-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:44279 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965020Ab2HVSii (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:38 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 37a1b90..84ddd30 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3801,7 +3801,7 @@ void
 qla83xx_nic_core_unrecoverable_work(struct work_struct *work)
 {
 	struct qla_hw_data *ha =
-		container_of(work, struct qla_hw_data, nic_core_reset);
+		container_of(work, struct qla_hw_data, nic_core_unrecoverable);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	uint32_t dev_state = 0;
 
@@ -3823,7 +3823,7 @@ void
 qla83xx_idc_state_handler_work(struct work_struct *work)
 {
 	struct qla_hw_data *ha =
-		container_of(work, struct qla_hw_data, nic_core_reset);
+		container_of(work, struct qla_hw_data, idc_state_handler);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 	uint32_t dev_state = 0;
 
-- 
1.7.7


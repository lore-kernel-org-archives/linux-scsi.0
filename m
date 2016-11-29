From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: megaraid-sas: fix spelling mistake of "outstanding"
Date: Tue, 29 Nov 2016 19:00:52 +0000
Message-ID: <20161129190052.8596-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55427 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbcK2TBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 14:01:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "oustanding" to "outstanding" in
dev_info and scmd_printk messages

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5462676..1470686 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2541,7 +2541,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 	do {
 		if ((fw_state == MFI_STATE_FAULT) || atomic_read(&instance->fw_outstanding)) {
 			dev_info(&instance->pdev->dev,
-				"%s:%d waiting_for_outstanding: before issue OCR. FW state = 0x%x, oustanding 0x%x\n",
+				"%s:%d waiting_for_outstanding: before issue OCR. FW state = 0x%x, outstanding 0x%x\n",
 				__func__, __LINE__, fw_state, atomic_read(&instance->fw_outstanding));
 			if (i == 3)
 				goto kill_hba_and_failed;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 24778ba..79e33bf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3240,7 +3240,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	if (!smid) {
 		ret = SUCCESS;
 		scmd_printk(KERN_NOTICE, scmd, "Command for which abort is"
-			" issued is not found in oustanding commands\n");
+			" issued is not found in outstanding commands\n");
 		mutex_unlock(&instance->reset_mutex);
 		goto out;
 	}
-- 
2.10.2


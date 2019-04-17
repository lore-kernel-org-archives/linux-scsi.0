From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: megaraid_sas: fix spelling mistake "oustanding" -> "outstanding"
Date: Wed, 17 Apr 2019 14:51:09 +0100
Message-ID: <20190417135109.12872-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in some kernel info and notice
messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1ec55ef00e30..473a120eb75d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2724,7 +2724,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 	do {
 		if ((fw_state == MFI_STATE_FAULT) || atomic_read(&instance->fw_outstanding)) {
 			dev_info(&instance->pdev->dev,
-				"%s:%d waiting_for_outstanding: before issue OCR. FW state = 0x%x, oustanding 0x%x\n",
+				"%s:%d waiting_for_outstanding: before issue OCR. FW state = 0x%x, outstanding 0x%x\n",
 				__func__, __LINE__, fw_state, atomic_read(&instance->fw_outstanding));
 			if (i == 3)
 				goto kill_hba_and_failed;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e35c2b64c145..6129399c1942 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4418,7 +4418,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	if (!smid) {
 		ret = SUCCESS;
 		scmd_printk(KERN_NOTICE, scmd, "Command for which abort is"
-			" issued is not found in oustanding commands\n");
+			" issued is not found in outstanding commands\n");
 		mutex_unlock(&instance->reset_mutex);
 		goto out;
 	}
-- 
2.20.1

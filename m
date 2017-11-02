From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: megaraid_sas:  fix spelling mistake: "thershold" -> "threshold"
Date: Thu,  2 Nov 2017 10:18:10 +0000
Message-ID: <20171102101810.18413-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_info message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ad162fed389c..569663bab771 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -283,7 +283,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 			(instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF) - MEGASAS_FUSION_IOCTL_CMDS;
 
 	dev_info(&instance->pdev->dev,
-		 "Current firmware supports maximum commands: %d\t LDIO thershold: %d\n",
+		 "Current firmware supports maximum commands: %d\t LDIO threshold: %d\n",
 		 cur_max_fw_cmds, ldio_threshold);
 
 	if (fw_boot_context == OCR_CONTEXT) {
-- 
2.14.1

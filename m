From: James Georgas <soulpa7ch@gmail.com>
Subject: [PATCH 1/1] scsi/megaraid: minor cut and paste error fixed.
Date: Wed, 26 Jun 2013 12:03:19 -0600
Message-ID: <1372269799-9835-1-git-send-email-soulpa7ch@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Georgas <soulpa7ch@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This looks like a cut and paste typo to me. Both of the
megasas_read_fw_status_reg_* functions involved are identical though, so
there was no bad behaviour. I changed it for consistency and clarity.

Signed-off-by: James Georgas <soulpa7ch@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3a9ddae..87591cd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -583,7 +583,7 @@ megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
 	/*
 	 * Check if it is our interrupt
 	 */
-	if ((megasas_read_fw_status_reg_gen2(regs) & MFI_STATE_MASK) ==
+	if ((megasas_read_fw_status_reg_skinny(regs) & MFI_STATE_MASK) ==
 	    MFI_STATE_FAULT) {
 		mfiStatus = MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
 	} else
-- 
1.8.1.5

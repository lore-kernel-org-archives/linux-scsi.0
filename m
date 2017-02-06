From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 35/39] megaraid_sas: Increase internal command pool
Date: Mon,  6 Feb 2017 02:00:08 -0800
Message-ID: <1486375212-17329-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36261 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbdBFKDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:03:20 -0500
Received: by mail-pg0-f42.google.com with SMTP id v184so27420154pgv.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:03:15 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix - increase internal command pool to 8.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 59fe39d..1a9a283 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1460,7 +1460,7 @@ enum FW_BOOT_CONTEXT {
  */
 #define MEGASAS_INT_CMDS			32
 #define MEGASAS_SKINNY_INT_CMDS			5
-#define MEGASAS_FUSION_INTERNAL_CMDS		5
+#define MEGASAS_FUSION_INTERNAL_CMDS		8
 #define MEGASAS_FUSION_IOCTL_CMDS		3
 #define MEGASAS_MFI_IOCTL_CMDS			27
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5dda73d..65971a9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1347,7 +1347,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 
 	/*
-	 * For fusion adapters, 3 commands for IOCTL and 5 commands
+	 * For fusion adapters, 3 commands for IOCTL and 8 commands
 	 * for driver's internal DCMDs.
 	 */
 	instance->max_scsi_cmds = instance->max_fw_cmds -
-- 
2.8.3

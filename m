From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 35/39] megaraid_sas: Increase internal command pool
Date: Fri, 10 Feb 2017 00:59:35 -0800
Message-ID: <1486717179-23320-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35545 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdBJJcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:32:31 -0500
Received: by mail-pg0-f47.google.com with SMTP id 194so9233653pgd.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:31:50 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix - increase internal command pool to 8.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 508516d..42c0e1f 100644
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
index d8bfb87..773ce34 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1350,7 +1350,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 
 	/*
-	 * For fusion adapters, 3 commands for IOCTL and 5 commands
+	 * For fusion adapters, 3 commands for IOCTL and 8 commands
 	 * for driver's internal DCMDs.
 	 */
 	instance->max_scsi_cmds = instance->max_fw_cmds -
-- 
2.8.3

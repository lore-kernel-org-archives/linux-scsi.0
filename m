From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 28/39] megaraid_sas: Remove unused pd_index from megasas_build_ld_nonrw_fusion
Date: Mon,  6 Feb 2017 02:00:01 -0800
Message-ID: <1486375212-17329-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36842 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750956AbdBFKCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:53 -0500
Received: by mail-pf0-f182.google.com with SMTP id 189so23086832pfu.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:48 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e74cbe6d..7f53505 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2477,7 +2477,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 {
 	u32 device_id;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
-	u16 pd_index = 0, ld;
+	u16 ld;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct fusion_context *fusion = instance->ctrl_context;
 	u8                          span, physArm;
@@ -2489,7 +2489,6 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 	io_request = cmd->io_request;
 	device_id = MEGASAS_DEV_INDEX(scmd);
-	pd_index = MEGASAS_PD_INDEX(scmd);
 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	/* get RAID_Context pointer */
-- 
2.8.3

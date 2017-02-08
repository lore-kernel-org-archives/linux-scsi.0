From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 29/39] megaraid_sas: Remove unused pd_index from megasas_build_ld_nonrw_fusion
Date: Wed,  8 Feb 2017 01:29:23 -0800
Message-ID: <1486546173-20713-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:33133 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933210AbdBHJb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:31:29 -0500
Received: by mail-pg0-f48.google.com with SMTP id 204so47596219pge.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:31:24 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 9e2a289..04a4c43 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2480,7 +2480,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 {
 	u32 device_id;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
-	u16 pd_index = 0, ld;
+	u16 ld;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct fusion_context *fusion = instance->ctrl_context;
 	u8                          span, physArm;
@@ -2492,7 +2492,6 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 
 	io_request = cmd->io_request;
 	device_id = MEGASAS_DEV_INDEX(scmd);
-	pd_index = MEGASAS_PD_INDEX(scmd);
 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
 	/* get RAID_Context pointer */
-- 
2.8.3

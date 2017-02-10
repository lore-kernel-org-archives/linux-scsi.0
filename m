From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 29/39] megaraid_sas: Remove unused pd_index from megasas_build_ld_nonrw_fusion
Date: Fri, 10 Feb 2017 00:59:29 -0800
Message-ID: <1486717179-23320-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33402 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750874AbdBJJI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:08:56 -0500
Received: by mail-pf0-f179.google.com with SMTP id c73so4633198pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:08:56 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
index 74cefae..a9b66ce 100644
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

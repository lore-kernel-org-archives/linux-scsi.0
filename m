From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 14/15] megaraid_sas: call megasas_dump_frame with correct IO frame size
Date: Fri, 30 Jun 2017 01:30:08 -0700
Message-ID: <1498811409-11157-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36124 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3Ibe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:31:34 -0400
Received: by mail-pg0-f43.google.com with SMTP id u62so60425009pgb.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:31:34 -0700 (PDT)
In-Reply-To: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c200f1a..c403e1d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2795,7 +2795,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 		cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
 		if (cmd)
 			megasas_dump_frame(cmd->io_request,
-				sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
+				MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE);
 		ret = megasas_reset_fusion(scmd->device->host,
 				SCSIIO_TIMEOUT_OCR);
 	} else
-- 
2.8.3

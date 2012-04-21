From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 1/3] [SCSI] ufs: Remove unused member sense_bufflen
Date: Sat, 21 Apr 2012 14:39:17 +0530
Message-ID: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2DUJJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 05:09:33 -0400
Received: by pbcun15 with SMTP id un15so1948683pbc.19
        for <linux-scsi@vger.kernel.org>; Sat, 21 Apr 2012 02:09:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

Remove unused member sense_bufflen from struct ufshcd_lrb.

Signed-off-by: Santosh Y <santoshsy@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52b96e8..3e4e102 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -194,7 +194,6 @@ struct ufs_hba {
  * @ucd_prdt_ptr: PRDT address of the command
  * @cmd: pointer to SCSI command
  * @sense_buffer: pointer to sense buffer address of the SCSI command
- * @sense_bufflen: Length of the sense buffer
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
@@ -208,7 +207,6 @@ struct ufshcd_lrb {
 
 	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
-	unsigned int sense_bufflen;
 	int scsi_status;
 
 	int command_type;
@@ -684,7 +682,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp = &hba->lrb[tag];
 
 	lrbp->cmd = cmd;
-	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = cmd->device->lun;
-- 
1.7.5.4


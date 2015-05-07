From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] scsi:qla4xxx: Fix typo in qla4xxx
Date: Thu,  7 May 2015 23:27:54 +0900
Message-ID: <1431008874-5522-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33364 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbEGO1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2015 10:27:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@qlogic.com, JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, Masanari Iida <standby24x7@gmail.com>

This patch fix spelling typo in printk within drivers/qla4xxx.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 2 +-
 drivers/scsi/qla4xxx/ql4_bsg.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 556c152..5d4f8e6 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -828,7 +828,7 @@ void qla4_83xx_read_reset_template(struct scsi_qla_host *ha)
 	ret_val = qla4_83xx_flash_read_u32(ha, addr, p_buff,
 					   tmplt_hdr_def_size);
 	if (ret_val != QLA_SUCCESS) {
-		ql4_printk(KERN_ERR, ha, "%s: Failed to read reset tempelate\n",
+		ql4_printk(KERN_ERR, ha, "%s: Failed to read reset template\n",
 			   __func__);
 		goto exit_read_template_error;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index 9f92cbf..415ee5e 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -571,7 +571,7 @@ static int qla4_83xx_pre_loopback_config(struct scsi_qla_host *ha,
 
 	if ((config & ENABLE_INTERNAL_LOOPBACK) ||
 	    (config & ENABLE_EXTERNAL_LOOPBACK)) {
-		ql4_printk(KERN_INFO, ha, "%s: Loopback diagnostics already in progress. Invalid requiest\n",
+		ql4_printk(KERN_INFO, ha, "%s: Loopback diagnostics already in progress. Invalid request\n",
 			   __func__);
 		goto exit_pre_loopback_config;
 	}
-- 
2.4.0.rc3.3.g6eb1401


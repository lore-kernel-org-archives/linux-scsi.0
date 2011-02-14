From: Fubo Chen <fubo.chen@gmail.com>
Subject: [PATCH] target: Remove unused variable
Date: Mon, 14 Feb 2011 20:09:48 +0100
Message-ID: <AANLkTi=dHh9Ombj=ZgA4AnPUyD3qo9kcr8z7UbXce-Or@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37161 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1BNTJt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 14:09:49 -0500
Received: by iyj8 with SMTP id 8so5128510iyj.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2011 11:09:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Does this patch make sense ?

---
 drivers/target/target_core_transport.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c
b/drivers/target/target_core_transport.c
index 236e22d..d0e1ce8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5828,14 +5828,12 @@ void transport_send_task_abort(struct se_cmd *cmd)
  */
 int transport_generic_do_tmr(struct se_cmd *cmd)
 {
-	struct se_cmd *ref_cmd;
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;

 	switch (tmr->function) {
 	case ABORT_TASK:
-		ref_cmd = tmr->ref_cmd;
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	case ABORT_TASK_SET:
-- 
1.7.1

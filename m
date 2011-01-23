From: Fubo Chen <fubo.chen@gmail.com>
Subject: [PATCH] target: Simplify T_TASK() CMD_TFO()
Date: Sun, 23 Jan 2011 15:06:41 +0100
Message-ID: <AANLkTinoi-TVNjs+V5Rqw73U6FH1j-G1ptpoHnN6CJdq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1AWOGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jan 2011 09:06:42 -0500
Received: by iyj18 with SMTP id 18so3168118iyj.19
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jan 2011 06:06:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

diff --git a/include/target/target_core_base.h
b/include/target/target_core_base.h
index 4139bf0..193bdfd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -537,8 +537,8 @@ struct se_cmd {
 	void (*transport_complete_callback)(struct se_cmd *);
 } ____cacheline_aligned;

-#define T_TASK(cmd)     ((struct se_transport_task *)(cmd->t_task))
-#define CMD_TFO(cmd) ((struct target_core_fabric_ops *)cmd->se_tfo)
+#define T_TASK(cmd)  ((cmd)->t_task)
+#define CMD_TFO(cmd) ((cmd)->se_tfo)

 struct se_tmr_req {
 	/* Task Management function to be preformed */

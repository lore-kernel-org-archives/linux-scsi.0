From: akpm@osdl.org
Subject: [patch 34/45] scsi_lib.c: use BUILD_BUG_ON
Date: Fri, 20 Oct 2006 14:48:32 -0700
Message-ID: <200610202148.k9KLmW6p004177@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:54662 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992786AbWJTVsq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi_libc-use-build_bug_on drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi_libc-use-build_bug_on
+++ a/drivers/scsi/scsi_lib.c
@@ -1084,7 +1084,7 @@ static void scsi_setup_blk_pc_cmnd(struc
 {
 	struct request *req = cmd->request;
 
-	BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
+	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)
_

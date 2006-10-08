From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] scsi_lib.c: use BUILD_BUG_ON
Date: Sun, 8 Oct 2006 15:55:55 +0400
Message-ID: <20061008115555.GC5344@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:26553 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751106AbWJHL4M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Oct 2006 07:56:12 -0400
Received: by nf-out-0910.google.com with SMTP id x30so1648233nfb
        for <linux-scsi@vger.kernel.org>; Sun, 08 Oct 2006 04:56:10 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1084,7 +1084,7 @@ static void scsi_setup_blk_pc_cmnd(struc
 {
 	struct request *req = cmd->request;
 
-	BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
+	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
 	cmd->cmd_len = req->cmd_len;
 	if (!req->data_len)


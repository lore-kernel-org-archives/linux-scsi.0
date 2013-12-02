From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_error: Fix typo
Date: Mon,  2 Dec 2013 07:54:56 +0100
Message-ID: <1385967296-99818-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab3LBGy7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Dec 2013 01:54:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>

sparse picked up a misguided switch() statement.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 04c2ce8..78b004d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1700,7 +1700,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
-	switch (status_byte(scmd->result) != CHECK_CONDITION)
+	if (status_byte(scmd->result) != CHECK_CONDITION)
 		return 0;
 
 check_type:
-- 
1.7.12.4


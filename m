From: Colin King <colin.king@canonical.com>
Subject: [PATCH] megaraid_sas: trivial fix, add missing space in dev_err message
Date: Mon, 25 Apr 2016 22:58:43 +0100
Message-ID: <1461621523-30162-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Add a missing space in dev_err message, missed because the string
spans a few lines.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e6ebc7a..1c038bc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3345,7 +3345,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 			if (!list_empty(&cmd->list)) {
 				dev_notice(&instance->pdev->dev, "ERROR while"
 					" moving this cmd:%p, %d %p, it was"
-					"discovered on some list?\n",
+					" discovered on some list?\n",
 					cmd, cmd->sync_cmd, cmd->scmd);
 
 				list_del_init(&cmd->list);
-- 
2.7.4

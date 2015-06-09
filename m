From: Colin King <colin.king@canonical.com>
Subject: [PATCH] megaraid_sas: insert missing space in kernel message
Date: Tue,  9 Jun 2015 16:53:43 +0100
Message-ID: <1433865223-15310-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbFIPzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 11:55:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The printk format specifier string is missing a space between
the %p format specifier and the "on the defer" text. Minor fix,
add the missing space.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..4889ef6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3148,7 +3148,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 		cmd = instance->cmd_list[i];
 		if (cmd->sync_cmd == 1 || cmd->scmd) {
 			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
-					"on the defer queue as internal\n",
+					" on the defer queue as internal\n",
 				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
 
 			if (!list_empty(&cmd->list)) {
-- 
2.1.4


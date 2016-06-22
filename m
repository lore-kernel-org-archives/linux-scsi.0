From: Colin King <colin.king@canonical.com>
Subject: [PATCH] target: fix spelling mistake: "limitiation" -> "limitation"
Date: Wed, 22 Jun 2016 19:31:51 +0100
Message-ID: <1466620311-26123-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbcFVScE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2016 14:32:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 75f0f08..4ebcd0a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -523,7 +523,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	 */
 	if (cmd->data_length > FD_MAX_BYTES) {
 		pr_err("FILEIO: Not able to process I/O of %u bytes due to"
-		       "FD_MAX_BYTES: %u iovec count limitiation\n",
+		       "FD_MAX_BYTES: %u iovec count limitation\n",
 			cmd->data_length, FD_MAX_BYTES);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-- 
2.8.1


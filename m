From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: a100u2w: trivial typo in printk
Date: Wed, 29 Jul 2015 19:19:45 +0100
Message-ID: <1438193985-7208-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbbG2SUO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2015 14:20:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Jiri Kosina <trivial@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial typo fix, \b should be \n

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/a100u2w.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index cac6b37..8086bd0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -888,7 +888,7 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 	scb->sense_len = SENSE_SIZE;
 	scb->cdb_len = cmd->cmd_len;
 	if (scb->cdb_len >= IMAX_CDB) {
-		printk("max cdb length= %x\b", cmd->cmd_len);
+		printk("max cdb length= %x\n", cmd->cmd_len);
 		scb->cdb_len = IMAX_CDB;
 	}
 	scb->ident = (u8)(cmd->device->lun & 0xff) | DISC_ALLOW;
-- 
2.4.6


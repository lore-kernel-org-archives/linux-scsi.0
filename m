From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: stex: make S6flag static
Date: Tue, 25 Apr 2017 18:36:19 +0100
Message-ID: <20170425173619.11955-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44916 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1952187AbdDYRg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:36:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Charles <charles.chiou@tw.promise.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

This module specific flag can be made static as it does
not need to be in global scope.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/stex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 0751561b59da..9b20643ab49d 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -363,7 +363,7 @@ struct st_card_info {
 	u16 sts_count;
 };
 
-int S6flag;
+static int S6flag;
 static int stex_halt(struct notifier_block *nb, ulong event, void *buf);
 static struct notifier_block stex_notifier = {
 	stex_halt, NULL, 0
-- 
2.11.0

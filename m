From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: hpsa: fix spelling mistake: "encrypytion" -> "encryption"
Date: Mon, 26 Jun 2017 14:31:10 +0100
Message-ID: <20170626133110.23590-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38834 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdFZNbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 09:31:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_info message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9934947073e6..8914eab84337 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3127,7 +3127,7 @@ static void hpsa_debug_map_buff(struct ctlr_info *h, int rc,
 			le16_to_cpu(map_buff->layout_map_count));
 	dev_info(&h->pdev->dev, "flags = 0x%x\n",
 			le16_to_cpu(map_buff->flags));
-	dev_info(&h->pdev->dev, "encrypytion = %s\n",
+	dev_info(&h->pdev->dev, "encryption = %s\n",
 			le16_to_cpu(map_buff->flags) &
 			RAID_MAP_FLAG_ENCRYPT_ON ?  "ON" : "OFF");
 	dev_info(&h->pdev->dev, "dekindex = %u\n",
-- 
2.11.0

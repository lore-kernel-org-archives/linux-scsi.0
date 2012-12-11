From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH] lpfc: init: fix misspelling word in mailbox command waiting comments
Date: Tue, 11 Dec 2012 11:50:59 +0800
Message-ID: <1355197859-17055-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37658 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2LKDsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Dec 2012 22:48:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: renmx@cn.fujitsu.com, james.smart@emulex.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Dayu <pandy.fnst@cn.fujitsu.com>

Correct misspelling of "outstanding" in mailbox command waiting comments.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
Signed-off-by: Pan Dayu <pandy.fnst@cn.fujitsu.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7dc4218..8533160 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2566,7 +2566,7 @@ lpfc_block_mgmt_io(struct lpfc_hba *phba, int mbx_action)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
-	/* Wait for the outstnading mailbox command to complete */
+	/* Wait for the outstanding mailbox command to complete */
 	while (phba->sli.mbox_active) {
 		/* Check active mailbox complete status every 2ms */
 		msleep(2);
-- 
1.7.1


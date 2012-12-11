From: renmx@cn.fujitsu.com
Subject: [PATCH] lpfc: init: fix misspelling word in mailbox command waiting comments
Date: Tue, 11 Dec 2012 11:53:38 +0800
Message-ID: <1355198018-17112-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: chenhanxiao@cn.fujitsu.com, james.smart@emulex.com
Cc: renmx@cn.fujitsu.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Dayu <pandy.fnst@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

From: Ren Mingxin <renmx@cn.fujitsu.com>

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

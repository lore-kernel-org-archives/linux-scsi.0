From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 03/19] Fix spelling in comments.
Date: Tue,  4 Apr 2017 10:16:56 -0700
Message-ID: <1491326232-11255-4-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38172 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755148AbdDDRZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:41 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 21AEE30C09F
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:26 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1c9fa45..7087c55 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6338,7 +6338,7 @@ lpfc_sli4_get_allocated_extnts(struct lpfc_hba *phba, uint16_t type,
 }
 
 /**
- * lpfc_sli4_repost_sgl_list - Repsot the buffers sgl pages as block
+ * lpfc_sli4_repost_sgl_list - Repost the buffers sgl pages as block
  * @phba: pointer to lpfc hba data structure.
  * @pring: Pointer to driver SLI ring object.
  * @sgl_list: linked link of sgl buffers to post
-- 
2.1.0

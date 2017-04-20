From: jsmart2021@gmail.com
Subject: [PATCH-v1 06/22] Fix spelling in comments.
Date: Wed, 19 Apr 2017 21:46:25 -0700
Message-ID: <20170420044641.10657-7-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34787 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941139AbdDTErF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:05 -0400
Received: by mail-oi0-f65.google.com with SMTP id y11so3466908oie.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:05 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

Comment should have said Repost.

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

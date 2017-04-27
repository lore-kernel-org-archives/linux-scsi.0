From: jsmart2021@gmail.com
Subject: [PATCH] lpfc: fix compile error when CONFIG_NVME_TARGET_FC not enabled
Date: Thu, 27 Apr 2017 12:35:47 -0700
Message-ID: <20170427193547.21553-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34050 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031818AbdD0Tf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 15:35:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id g23so13286774pfj.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2017 12:35:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

fix compile error when CONFIG_NVME_TARGET_FC not enabled

return statement needs to be outside of ifdef

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
Patch to be pulled in via block trees

Patch cut against nvme-4.12 tree


 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 90527e7..4da99db 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -958,8 +958,8 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
 
 	/* Respond with BA_RJT accordingly */
 	lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 0);
-	return 0;
 #endif
+	return 0;
 }
 
 void
-- 
2.9.3

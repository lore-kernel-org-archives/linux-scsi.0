From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 05/20] lpfc: convert info messages to standard messages
Date: Fri,  4 Aug 2017 17:47:16 -0700
Message-ID: <20170805004731.1335-6-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37701 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdHEAru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:47:50 -0400
Received: by mail-pg0-f65.google.com with SMTP id 83so3108058pgb.4
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:47:49 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Transitioned some informational discovery messages to now always
be displayed when log_verbose is set.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 9c0c1463057d..33417681f5d4 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -955,7 +955,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		CTrsp = (struct lpfc_sli_ct_request *)outp->virt;
 		fc4_data_0 = be32_to_cpu(CTrsp->un.gft_acc.fc4_types[0]);
 		fc4_data_1 = be32_to_cpu(CTrsp->un.gft_acc.fc4_types[1]);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "3062 DID x%06x GFT Wd0 x%08x Wd1 x%08x\n",
 				 did, fc4_data_0, fc4_data_1);
 
@@ -969,7 +969,7 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				ndlp->nlp_fc4_type |= NLP_FC4_FCP;
 			if (fc4_data_1 &  LPFC_FC4_TYPE_BITMASK)
 				ndlp->nlp_fc4_type |= NLP_FC4_NVME;
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "3064 Setting ndlp %p, DID x%06x with "
 					 "FC4 x%08x, Data: x%08x x%08x\n",
 					 ndlp, did, ndlp->nlp_fc4_type,
-- 
2.13.1

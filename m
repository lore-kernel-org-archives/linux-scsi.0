From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 05/20] lpfc: convert info messages to standard messages
Date: Wed, 23 Aug 2017 16:55:34 -0700
Message-ID: <20170823235549.2883-6-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33009 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdHWX4K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:10 -0400
Received: by mail-wr0-f193.google.com with SMTP id j21so595636wre.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:10 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Transitioned some informational discovery messages to now always
be displayed when log_verbose is set.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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

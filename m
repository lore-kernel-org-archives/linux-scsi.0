From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 06/17] lpfc: Raise maximum NVME sg list size for 256 elements
Date: Mon, 20 Nov 2017 16:00:33 -0800
Message-ID: <20171121000044.27702-7-jsmart2021@gmail.com>
References: <20171121000044.27702-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:46735 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdKUABB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:01:01 -0500
Received: by mail-qk0-f194.google.com with SMTP id b85so9760178qkc.13
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:01:00 -0800 (PST)
In-Reply-To: <20171121000044.27702-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Raise the maximum NVME sg list size allowed to 256 elements.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 7219b6ce5dc7..46a89bdff8e4 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -57,7 +57,7 @@ struct lpfc_sli2_slim;
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
 #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
 #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
-#define LPFC_MAX_NVME_SEG_CNT	128	/* max SGL element cnt per NVME cmnd */
+#define LPFC_MAX_NVME_SEG_CNT	256	/* max SGL element cnt per NVME cmnd */
 
 #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
-- 
2.13.1

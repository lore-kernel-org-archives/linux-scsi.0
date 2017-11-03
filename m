From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 06/17] lpfc: Raise maximum NVME sg list size for 256 elements
Date: Fri,  3 Nov 2017 15:56:17 -0700
Message-ID: <20171103225628.24716-7-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:51595 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756073AbdKCW4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:43 -0400
Received: by mail-qt0-f194.google.com with SMTP id h4so5041723qtk.8
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:43 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Raise the maximum NVME sg list size allowed to 256 elements.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
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

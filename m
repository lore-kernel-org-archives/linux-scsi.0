From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 06/17] lpfc: Raise maximum NVME sg list size for 256 elements
Date: Thu,  9 Nov 2017 17:08:23 -0800
Message-ID: <20171110010834.4542-7-jsmart2021@gmail.com>
References: <20171110010834.4542-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:56506 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbdKJBIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 20:08:49 -0500
Received: by mail-qk0-f193.google.com with SMTP id 2so9301989qkg.13
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 17:08:49 -0800 (PST)
In-Reply-To: <20171110010834.4542-1-jsmart2021@gmail.com>
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

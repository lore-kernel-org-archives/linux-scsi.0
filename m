From: jsmart2021@gmail.com
Subject: [PATCH v3 07/22] Remove unused defines for NVME PostBuf.
Date: Fri, 21 Apr 2017 16:04:51 -0700
Message-ID: <20170421230506.925-8-jsmart2021@gmail.com>
References: <20170421230506.925-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33003 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041162AbdDUXFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 19:05:21 -0400
Received: by mail-oi0-f67.google.com with SMTP id a189so23915886oib.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 16:05:21 -0700 (PDT)
In-Reply-To: <20170421230506.925-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

These defines for the posting of buffers for nvmet target were not used.

Removing the unused defines.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 6277796..2582f46 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -22,9 +22,6 @@
  ********************************************************************/
 
 #define LPFC_NVME_DEFAULT_SEGS		(64 + 1)	/* 256K IOs */
-#define LPFC_NVMET_MIN_POSTBUF		16
-#define LPFC_NVMET_DEFAULT_POSTBUF	1024
-#define LPFC_NVMET_MAX_POSTBUF		4096
 #define LPFC_NVME_WQSIZE		256
 
 #define LPFC_NVME_ERSP_LEN		0x20
-- 
2.9.3

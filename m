From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 18/21] lpfc: remove console log clutter
Date: Wed,  2 Aug 2017 16:36:45 -0700
Message-ID: <20170802233648.4573-19-jsmart2021@gmail.com>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38491 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751987AbdHBXiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 19:38:20 -0400
Received: by mail-qt0-f193.google.com with SMTP id p3so6126799qtg.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 16:38:19 -0700 (PDT)
In-Reply-To: <20170802233648.4573-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Change hw queue binding messages to info - not error.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8e7cdbd5d7d3..d3c171a72ae0 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -110,7 +110,7 @@ lpfc_nvme_create_queue(struct nvme_fc_local_port *pnvme_lport,
 		qhandle->index = qidx;
 	}
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
 			 "6073 Binding %s HdwQueue %d  (cpu %d) to "
 			 "io_channel %d qhandle %p\n", str,
 			 qidx, qhandle->cpu_id, qhandle->index, qhandle);
-- 
2.13.1

From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 17/20] lpfc: remove console log clutter
Date: Fri,  4 Aug 2017 17:47:28 -0700
Message-ID: <20170805004731.1335-18-jsmart2021@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33267 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752697AbdHEAsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 20:48:11 -0400
Received: by mail-pg0-f66.google.com with SMTP id u185so3142974pgb.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2017 17:48:11 -0700 (PDT)
In-Reply-To: <20170805004731.1335-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

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

From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 17/20] lpfc: remove console log clutter
Date: Wed, 23 Aug 2017 16:55:46 -0700
Message-ID: <20170823235549.2883-18-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36905 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdHWX4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:34 -0400
Received: by mail-wr0-f196.google.com with SMTP id 72so585402wrc.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:34 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Change hw queue binding messages to info - not error.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index bb9ede2521b9..79ba3ce063a4 100644
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

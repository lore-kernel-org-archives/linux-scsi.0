From: jsmart2021@gmail.com
Subject: [PATCH-v1 09/22] Fix extra line print in rqpair debug print.
Date: Wed, 19 Apr 2017 21:46:28 -0700
Message-ID: <20170420044641.10657-10-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35935 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941145AbdDTErJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:09 -0400
Received: by mail-oi0-f65.google.com with SMTP id a3so346482oii.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:09 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

An extra blank line was being added the the rqpair printing.

Remove the extra line feed.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 76857e2..55a8d8f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -3128,8 +3128,6 @@ __lpfc_idiag_print_rqpair(struct lpfc_queue *qp, struct lpfc_queue *datqp,
 			datqp->queue_id, datqp->entry_count,
 			datqp->entry_size, datqp->host_index,
 			datqp->hba_index);
-	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
-
 	return len;
 }
 
-- 
2.1.0

From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/22] lpfc 8.3.39: Doorbell formation information logged in
 dual-chute mode WQ and RQ setup
Date: Wed, 17 Apr 2013 20:16:37 -0400
Message-ID: <1366244197.1513.8.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15659 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab3DRAQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:16:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Doorbell formation information logged in dual-chute mode WQ and RQ setup


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:26.986040891 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:26:35.021041074 -0400
@@ -12909,8 +12909,9 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 		}
 		wq->db_regaddr = bar_memmap_p + db_offset;
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3264 WQ[%d]: barset:x%x, offset:x%x\n",
-				wq->queue_id, pci_barset, db_offset);
+				"3264 WQ[%d]: barset:x%x, offset:x%x, "
+				"format:x%x\n", wq->queue_id, pci_barset,
+				db_offset, wq->db_format);
 	} else {
 		wq->db_format = LPFC_DB_LIST_FORMAT;
 		wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
@@ -13130,8 +13131,9 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 		}
 		hrq->db_regaddr = bar_memmap_p + db_offset;
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"3266 RQ[qid:%d]: barset:x%x, offset:x%x\n",
-				hrq->queue_id, pci_barset, db_offset);
+				"3266 RQ[qid:%d]: barset:x%x, offset:x%x, "
+				"format:x%x\n", hrq->queue_id, pci_barset,
+				db_offset, hrq->db_format);
 	} else {
 		hrq->db_format = LPFC_DB_RING_FORMAT;
 		hrq->db_regaddr = phba->sli4_hba.RQDBregaddr;




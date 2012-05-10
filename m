From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/20] lpfc 8.3.31: Fix unable to create vports on FCoE SLI4
 adapter
Date: Wed, 9 May 2012 21:16:50 -0400
Message-ID: <1336612619.1996.34.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27878 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755245Ab2EJBRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:17:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix unable to create vports on FCoE SLI4 adapter


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:00:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:05.000000000 -0400
@@ -7895,7 +7895,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 					iocbq->vport->fc_myDID);
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 1);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,
-					phba->vpi_ids[phba->pport->vpi]);
+					phba->vpi_ids[iocbq->vport->vpi]);
 			} else if (pcmd && iocbq->context1) {
 				bf_set(wqe_ct, &wqe->els_req.wqe_com, 0);
 				bf_set(wqe_ctxt_tag, &wqe->els_req.wqe_com,




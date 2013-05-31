From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/17] lpfc 8.3.40: Fixed some logging message fields
Date: Fri, 31 May 2013 17:04:28 -0400
Message-ID: <1370034268.17258.30.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5793 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3EaVLC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed some logging message fields


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:19.924057676 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:20.537057690 -0400
@@ -8713,7 +8713,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 			"3116 Port generated FCP XRI ABORT event on "
 			"vpi %d rpi %d xri x%x status 0x%x parameter x%x\n",
-			ndlp->vport->vpi, ndlp->nlp_rpi,
+			ndlp->vport->vpi, phba->sli4_hba.rpi_ids[ndlp->nlp_rpi],
 			bf_get(lpfc_wcqe_xa_xri, axri),
 			bf_get(lpfc_wcqe_xa_status, axri),
 			axri->parameter);
@@ -9769,7 +9769,7 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba
 			struct lpfc_iocbq *rspiocb)
 {
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"3096 ABORT_XRI_CN completing on xri x%x "
+			"3096 ABORT_XRI_CN completing on rpi x%x "
 			"original iotag x%x, abort cmd iotag x%x "
 			"status 0x%x, reason 0x%x\n",
 			cmdiocb->iocb.un.acxri.abortContextTag,




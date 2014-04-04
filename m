From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/11] lpfc 10.2.8000.0: Fix dynamic transitions of
 FirstBurst from on to off
Date: Fri, 4 Apr 2014 13:51:25 -0400
Message-ID: <1396633885.1924.14.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:53466 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaDDRv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:51:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix dynamic transitions of FirstBurst from on to off


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2014-03-31 16:21:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2014-04-03 10:24:16.597308319 -0400
@@ -4314,6 +4314,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 		fcp_cmnd->fcpCntl1 = SIMPLE_Q;
 
 	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
+	piocbq->iocb.un.fcpi.fcpi_XRdy = 0;
 
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use




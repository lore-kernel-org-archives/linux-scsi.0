From: James Smart <james.smart@emulex.com>
Subject: [PATCH 8/13] lpfc 8.3.41: Fixed failure in setting SLI3 board mode
Date: Mon, 15 Jul 2013 18:34:22 -0400
Message-ID: <1373927662.15647.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19230 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3GOWeZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:34:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed failure in setting SLI3 board mode


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    3 ---
 1 file changed, 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:17.540055827 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-07-15 07:15:26.536056032 -0400
@@ -674,9 +674,6 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 	int i;
 	int rc;
 
-	if (phba->pport->fc_flag & FC_OFFLINE_MODE)
-		return 0;
-
 	init_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl,
 			      LPFC_EVT_OFFLINE_PREP);






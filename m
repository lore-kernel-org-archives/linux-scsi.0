From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/13] lpfc 8.3.41: Fix mailbox byteswap issue on PPC
Date: Mon, 15 Jul 2013 18:32:00 -0400
Message-ID: <1373927520.15647.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19208 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350Ab3GOWcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:32:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix mailbox byteswap issue on PPC


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    1 -
 1 file changed, 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:01.997055473 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:08.819055628 -0400
@@ -10161,7 +10161,6 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 		 */
 		if (pmboxq->mbox_flag & LPFC_MBX_WAKE) {
 			retval = MBX_SUCCESS;
-			lpfc_sli4_swap_str(phba, pmboxq);
 		} else {
 			retval = MBX_TIMEOUT;
 			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;





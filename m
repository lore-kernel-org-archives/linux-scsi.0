From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/11] lpfc 8.3.37: Fix potential memory corruption bug
Date: Thu, 3 Jan 2013 15:43:45 -0500
Message-ID: <1357245825.2628.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:27034 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3ACUtb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:49:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix potential memory corruption bug


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:05.944087718 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-01-02 13:13:07.035087742 -0500
@@ -8370,7 +8370,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 		 * This is a continuation of a commandi,(CX) so this
 		 * sglq is on the active list
 		 */
-		sglq = __lpfc_get_active_sglq(phba, piocb->sli4_xritag);
+		sglq = __lpfc_get_active_sglq(phba, piocb->sli4_lxritag);
 		if (!sglq)
 			return IOCB_ERROR;
 	}





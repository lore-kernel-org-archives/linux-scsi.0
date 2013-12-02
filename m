From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/7] lpfc 8.3.44: Fixed unassigned variable in ELS timeout
 message
Date: Mon, 2 Dec 2013 12:49:18 -0500
Message-ID: <1386006558.11046.14.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:40832 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3LBRuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 12:50:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed unassigned variable in ELS timeout message


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |    1 +
 1 file changed, 1 insertion(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2013-12-02 11:52:15.626242133 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-12-02 11:52:18.739242204 -0500
@@ -6307,6 +6307,7 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	spin_unlock_irq(&phba->hbalock);
 
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
+		cmd = &piocb->iocb;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 			 "0127 ELS timeout Data: x%x x%x x%x "
 			 "x%x\n", els_command,




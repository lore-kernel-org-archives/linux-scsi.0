From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/21] lpfc: Initiator sends wrong BBCredit value for either
 FLOGI or FLOGI_ACC
Date: Fri, 3 Apr 2015 17:12:23 -0400
Message-ID: <1428095543.6933.41.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:1288 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbbDCVMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 17:12:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Initiator sends wrong BBCredit value for either FLOGI or FLOGI_ACC

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9f3c74e..f73d58c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5197,7 +5197,6 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		port_state = vport->port_state;
 		vport->fc_flag |= FC_PT2PT;
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
-		vport->port_state = LPFC_FLOGI;
 		spin_unlock_irq(shost->host_lock);
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "3311 Rcv Flogi PS x%x new PS x%x "
-- 
1.7.11.7





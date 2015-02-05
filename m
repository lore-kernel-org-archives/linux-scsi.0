From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/21] lpfc: Initiator sends wrong BBCredit value for either
 FLOGI or FLOGI_ACC
Date: Thu, 5 Feb 2015 14:25:02 -0500
Message-ID: <1423164302.7917.37.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:20686 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbBETZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:25:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


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

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>




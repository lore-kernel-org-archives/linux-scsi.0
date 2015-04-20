From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/14] lpfc: Change buffer pool empty message to
 miscellaneous category
Date: Mon, 20 Apr 2015 09:56:37 -0400
Message-ID: <55350595.rFSb9xD4qNehcNA1%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:30920 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbbDTN5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change buffer pool empty message to miscellaneous category

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cb73cf9..6228bce 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4536,7 +4536,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_MISC,
 				 "0707 driver's buffer pool is empty, "
 				 "IO busied\n");
 		goto out_host_busy;
-- 
1.7.11.7


From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/18] lpfc 8.3.42: Fixed function mode field defined too
 small for not recognizing dual-chute mode
Date: Fri, 6 Sep 2013 12:19:27 -0400
Message-ID: <1378484367.14051.25.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22780 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3IFQUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:20:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed function mode field defined too small for not recognizing dual-chute mode


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2013-09-06 10:04:10.607058455 -0400
@@ -523,7 +523,7 @@ struct lpfc_sli4_hba {
 	struct lpfc_queue *hdr_rq; /* Slow-path Header Receive queue */
 	struct lpfc_queue *dat_rq; /* Slow-path Data Receive queue */
 
-	uint8_t fw_func_mode;	/* FW function protocol mode */
+	uint32_t fw_func_mode;	/* FW function protocol mode */
 	uint32_t ulp0_mode;	/* ULP0 protocol mode */
 	uint32_t ulp1_mode;	/* ULP1 protocol mode */
 




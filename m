From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/17] lpfc 8.3.40: Fixed a missing return code in a logging
 message
Date: Fri, 31 May 2013 17:04:36 -0400
Message-ID: <1370034276.17258.31.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5797 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3EaVLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed a missing return code in a logging message


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:20.537057690 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:21.732057717 -0400
@@ -4566,7 +4566,8 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 		} else {
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"2708 This device does not support "
-					"Advanced Error Reporting (AER)\n");
+					"Advanced Error Reporting (AER): %d\n",
+					rc);
 			phba->cfg_aer_support = 0;
 		}
 	}




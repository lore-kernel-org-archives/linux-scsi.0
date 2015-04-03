From: James Smart <james.smart@emulex.com>
Subject: [PATCH 01/21] lpfc: Fix the iteration count to match the 30 sec
 comment in the routine lpfc_pci_function_reset
Date: Fri, 3 Apr 2015 17:10:21 -0400
Message-ID: <1428095421.6933.29.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:56218 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbDCVLK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 17:11:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix the iteration count to match the 30 sec comment in the routine lpfc_pci_function_reset

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0b2c53a..2b5b910 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7953,7 +7953,7 @@ wait:
 		 * up to 30 seconds. If the port doesn't respond, treat
 		 * it as an error.
 		 */
-		for (rdy_chk = 0; rdy_chk < 3000; rdy_chk++) {
+		for (rdy_chk = 0; rdy_chk < 1500; rdy_chk++) {
 			if (lpfc_readl(phba->sli4_hba.u.if_type2.
 				STATUSregaddr, &reg_data.word0)) {
 				rc = -ENODEV;
-- 
1.7.11.7





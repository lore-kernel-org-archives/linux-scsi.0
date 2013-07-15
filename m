From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/13] lpfc 8.3.41: Fixed the format of some log message
 fields
Date: Mon, 15 Jul 2013 18:35:21 -0400
Message-ID: <1373927721.15647.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4565 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3GOWfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:35:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed the format of some log message fields


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_ct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2013-07-15 07:15:32.810056175 -0400
@@ -895,7 +895,7 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, stru
 
 	if (irsp->ulpStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
-				 "0268 NS cmd %x Error (%d %d)\n",
+				 "0268 NS cmd x%x Error (x%x x%x)\n",
 				 cmdcode, irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&





From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/12] lpfc 8.3.34: Adjust IO Channels to 1 when INTx
Date: Tue, 14 Aug 2012 14:26:20 -0400
Message-ID: <1344968780.4432.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26708 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab2HNS0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adjust IO Channels to 1 when INTx


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:24:51.775924271 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:24:52.550924244 -0400
@@ -9524,7 +9524,7 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		}
 		/* Default to single EQ for non-MSI-X */
 		if (phba->intr_type != MSIX)
-			adjusted_fcp_io_channel = 0;
+			adjusted_fcp_io_channel = 1;
 		else if (phba->sli4_hba.msix_vec_nr <
 					phba->cfg_fcp_io_channel)
 			adjusted_fcp_io_channel = phba->sli4_hba.msix_vec_nr;




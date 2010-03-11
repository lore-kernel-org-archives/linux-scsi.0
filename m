From: akpm@linux-foundation.org
Subject: [patch 22/26] lpfc: positive error return into negative
Date: Thu, 11 Mar 2010 14:09:56 -0800
Message-ID: <201003112209.o2BM9uWY013679@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348Ab0CKWKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:10:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, james.smart@emulex.com

From: Roel Kluin <roel.kluin@gmail.com>

In the comment on top of lpfc_sli_hbq_setup() and of its caller which
transmits this error, lpfc_sli_hba_setup(), it is stated that the function
should return a negative error code.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_sli.c~lpfc-positive-error-return-into-negative drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~lpfc-positive-error-return-into-negative
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -3791,7 +3791,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 
 			phba->link_state = LPFC_HBA_ERROR;
 			mempool_free(pmb, phba->mbox_mem_pool);
-			return ENXIO;
+			return -ENXIO;
 		}
 	}
 	phba->hbq_count = hbq_count;
_

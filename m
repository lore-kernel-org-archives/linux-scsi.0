From: akpm@linux-foundation.org
Subject: [patch 17/28] lpfc: positive error return into negative
Date: Tue, 27 Apr 2010 14:23:01 -0700
Message-ID: <201004272123.o3RLN1lx020829@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121Ab0D0V1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:27:46 -0400
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
@@ -3794,7 +3794,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 
 			phba->link_state = LPFC_HBA_ERROR;
 			mempool_free(pmb, phba->mbox_mem_pool);
-			return ENXIO;
+			return -ENXIO;
 		}
 	}
 	phba->hbq_count = hbq_count;
_

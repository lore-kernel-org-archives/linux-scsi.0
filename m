From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] lpfc: Positive error return into negative
Date: Fri, 29 Jan 2010 11:09:10 +0100
Message-ID: <4B62B3C6.5090903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932356Ab0A2KDY@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

In the comment on top of lpfc_sli_hbq_setup() and of its caller which
transmits this error, lpfc_sli_hba_setup(), it is stated that the
function should return a negative error code.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 589549b..a960736 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3709,7 +3709,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 
 			phba->link_state = LPFC_HBA_ERROR;
 			mempool_free(pmb, phba->mbox_mem_pool);
-			return ENXIO;
+			return -ENXIO;
 		}
 	}
 	phba->hbq_count = hbq_count;

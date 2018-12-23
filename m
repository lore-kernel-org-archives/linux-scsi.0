From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 05/20] scsi: lpfc: lpfc_sli: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:00 +0100
Message-ID: <1545555435-24576-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Drop LIST_HEAD where the variable it declares has never
been used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 895427bd012ce ("scsi: lpfc: NVME Initiator: Base modifications")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/scsi/lpfc/lpfc_sli.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 30734caf77e1..13fe9d3331b9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3948,7 +3948,6 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 void
 lpfc_sli_abort_wqe_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
-	LIST_HEAD(completions);
 	struct lpfc_iocbq *iocb, *next_iocb;
 
 	if (pring->ringno == LPFC_ELS_RING)

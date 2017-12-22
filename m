From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: fix a couple of minor indentation issues
Date: Fri, 22 Dec 2017 00:39:36 +0000
Message-ID: <20171222003936.11297-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Several statements are indented too far, fix these

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index dfb21d9efb0d..234c7c015982 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6862,7 +6862,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		return 1;
 
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
-		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
 	pcmd += sizeof(uint32_t); /* Skip past command */
 
 	/* use the command's xri in the response */
@@ -8155,9 +8155,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			lpfc_nlp_put(ndlp);
 		break;
 	case ELS_CMD_REC:
-			/* receive this due to exchange closed */
-			rjt_err = LSRJT_UNABLE_TPC;
-			rjt_exp = LSEXP_INVALID_OX_RX;
+		/* receive this due to exchange closed */
+		rjt_err = LSRJT_UNABLE_TPC;
+		rjt_exp = LSEXP_INVALID_OX_RX;
 		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
-- 
2.14.1


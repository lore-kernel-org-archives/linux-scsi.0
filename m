From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 26/41] scsi: lpfc: lpfc_nvme: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:31:49 -0600
Message-ID: <79e1e3ed62a02dc3caf264f6960e7be68bbbc70c.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index ba831def9301..942fe58c433d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1115,6 +1115,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 					 lpfc_ncmd, nCmd,
 					 lpfc_ncmd->cur_iocbq.sli4_xritag,
 					 bf_get(lpfc_wcqe_c_xb, wcqe));
+			/* fall through */
 		default:
 out_err:
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
-- 
2.17.1

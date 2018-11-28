From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 25/41] scsi: lpfc: lpfc_nportdisc: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:31:33 -0600
Message-ID: <8d1c41fb93d54415cfd0a8c1fa6d31a6a76db461.1543374820.git.gustavo@embeddedor.com>
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
 drivers/scsi/lpfc/lpfc_nportdisc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 7d5693cfaa87..e8583496feaf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -360,6 +360,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
 			break;
+		/* fall through */
 	case  NLP_STE_REG_LOGIN_ISSUE:
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
-- 
2.17.1

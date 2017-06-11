From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 3/3] scsi: qedf: Merge a few quoted strings split across lines
Date: Sun, 11 Jun 2017 08:16:04 +0200
Message-ID: <fdd13b3850e2b50f1f7f71b98aeb381b77546f1b.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:37483 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdFKGQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jun 2017 02:16:21 -0400
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
References: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Merge some quoted strings to improve readability and to save some lines
of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/qedf/qedf_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 19a2bbc65f54..d1e8b167a117 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -975,8 +975,7 @@ static int qedf_alloc_sq(struct qedf_ctx *qedf, struct qedf_rport *fcport)
 	fcport->sq = dma_zalloc_coherent(&qedf->pdev->dev,
 	    fcport->sq_mem_size, &fcport->sq_dma, GFP_KERNEL);
 	if (!fcport->sq) {
-		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send "
-			   "queue.\n");
+		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send queue.\n");
 		rval = 1;
 		goto out;
 	}
@@ -984,8 +983,7 @@ static int qedf_alloc_sq(struct qedf_ctx *qedf, struct qedf_rport *fcport)
 	fcport->sq_pbl = dma_zalloc_coherent(&qedf->pdev->dev,
 	    fcport->sq_pbl_size, &fcport->sq_pbl_dma, GFP_KERNEL);
 	if (!fcport->sq_pbl) {
-		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send "
-			   "queue PBL.\n");
+		QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate send queue PBL.\n");
 		rval = 1;
 		goto out_free_sq;
 	}
@@ -2598,8 +2596,7 @@ static int qedf_alloc_bdq(struct qedf_ctx *qedf)
 	qedf->bdq_pbl_list = dma_zalloc_coherent(&qedf->pdev->dev,
 	    QEDF_PAGE_SIZE, &qedf->bdq_pbl_list_dma, GFP_KERNEL);
 	if (!qedf->bdq_pbl_list) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Could not allocate list of PBL "
-		    "pages.\n");
+		QEDF_ERR(&(qedf->dbg_ctx), "Could not allocate list of PBL pages.\n");
 		return -ENOMEM;
 	}
 
@@ -2691,8 +2688,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 			&qedf->global_queues[i]->cq_dma, GFP_KERNEL);
 
 		if (!qedf->global_queues[i]->cq) {
-			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate "
-				   "cq.\n");
+			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate cq.\n");
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
@@ -2703,8 +2699,7 @@ static int qedf_alloc_global_queues(struct qedf_ctx *qedf)
 			&qedf->global_queues[i]->cq_pbl_dma, GFP_KERNEL);
 
 		if (!qedf->global_queues[i]->cq_pbl) {
-			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate "
-				   "cq PBL.\n");
+			QEDF_WARN(&(qedf->dbg_ctx), "Could not allocate cq PBL.\n");
 			status = -ENOMEM;
 			goto mem_alloc_failure;
 		}
@@ -2800,8 +2795,7 @@ static int qedf_set_fcoe_pf_param(struct qedf_ctx *qedf)
 	cq_mem_size = ALIGN(cq_mem_size, QEDF_PAGE_SIZE);
 	cq_num_entries = cq_mem_size / sizeof(struct fcoe_cqe);
 
-	memset(&(qedf->pf_params), 0,
-	    sizeof(qedf->pf_params));
+	memset(&(qedf->pf_params), 0, sizeof(qedf->pf_params));
 
 	/* Setup the value for fcoe PF */
 	qedf->pf_params.fcoe_pf_params.num_cons = QEDF_MAX_SESSIONS;
-- 
2.11.0

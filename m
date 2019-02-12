From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: fix a handful of indentation issues
Date: Tue, 12 Feb 2019 15:29:45 +0000
Message-ID: <20190212152945.11362-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a handful of statements that are indented incorrectly. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c     | 4 ++--
 drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
 drivers/scsi/lpfc/lpfc_init.c    | 2 +-
 drivers/scsi/lpfc/lpfc_mbox.c    | 4 ++--
 drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 2dc564e59430..f2494d3b365c 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2947,7 +2947,7 @@ static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 			cmd->un.cont64[i].addrLow = putPaddrLow(mp[i]->phys);
 			cmd->un.cont64[i].tus.f.bdeSize =
 				((struct lpfc_dmabufext *)mp[i])->size;
-					cmd->ulpBdeCount = ++i;
+			cmd->ulpBdeCount = ++i;
 
 			if ((--num_bde > 0) && (i < 2))
 				continue;
@@ -4682,7 +4682,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	 * Don't allow mailbox commands to be sent when blocked or when in
 	 * the middle of discovery
 	 */
-	 if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
+	if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
 		rc = -EAGAIN;
 		goto job_done;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index ee98ea1c68f9..1215eaa530db 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1833,7 +1833,7 @@ lpfc_debugfs_disc_trc_open(struct inode *inode, struct file *file)
 	int rc = -ENOMEM;
 
 	if (!lpfc_debugfs_max_disc_trc) {
-		 rc = -ENOSPC;
+		rc = -ENOSPC;
 		goto out;
 	}
 
@@ -1883,7 +1883,7 @@ lpfc_debugfs_slow_ring_trc_open(struct inode *inode, struct file *file)
 	int rc = -ENOMEM;
 
 	if (!lpfc_debugfs_max_slow_ring_trc) {
-		 rc = -ENOSPC;
+		rc = -ENOSPC;
 		goto out;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 900edae7ccc4..18424020ae40 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10118,7 +10118,7 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba *phba)
 			dev_printk(KERN_ERR, &pdev->dev,
 				"ioremap failed for SLI4 PCI config "
 				"registers.\n");
-				goto out;
+			goto out;
 		}
 		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 4d3b94317515..8abe933bad09 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2095,8 +2095,8 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 	if (phba->nvmet_support) {
 		bf_set(lpfc_mbx_rq_ftr_rq_mrqp, &mboxq->u.mqe.un.req_ftrs, 1);
 		/* iaab/iaar NOT set for now */
-		 bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
-		 bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
+		bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
+		bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
 	}
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3596822605c3..d0817facdae3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1008,7 +1008,7 @@ lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	if (!ndlp->active_rrqs_xri_bitmap)
 		return 0;
 	if (test_bit(xritag, ndlp->active_rrqs_xri_bitmap))
-			return 1;
+		return 1;
 	else
 		return 0;
 }
-- 
2.20.1

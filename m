From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: lpfc: fix spelling mistakes: "mabilbox" and "maibox"
Date: Thu,  3 May 2018 10:26:12 +0100
Message-ID: <20180503092612.30007-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistakes in lpfc_printf_log log message

"mabilbox" -> "mailbox"
"maibox" -> "mailbox"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Add maibox fixes

---
 drivers/scsi/lpfc/lpfc_bsg.c  | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_init.c |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 0f174ca80f67..edb1a18a6414 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3621,7 +3621,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		bsg_reply->result = 0;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
-				"2937 SLI_CONFIG ext-buffer maibox command "
+				"2937 SLI_CONFIG ext-buffer mailbox command "
 				"(x%x/x%x) complete bsg job done, bsize:%d\n",
 				phba->mbox_ext_buf_ctx.nembType,
 				phba->mbox_ext_buf_ctx.mboxType, size);
@@ -3632,7 +3632,7 @@ lpfc_bsg_issue_mbox_ext_handle_job(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 					phba->mbox_ext_buf_ctx.mbx_dmabuf, 0);
 	} else {
 		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
-				"2938 SLI_CONFIG ext-buffer maibox "
+				"2938 SLI_CONFIG ext-buffer mailbox "
 				"command (x%x/x%x) failure, rc:x%x\n",
 				phba->mbox_ext_buf_ctx.nembType,
 				phba->mbox_ext_buf_ctx.mboxType, rc);
@@ -3666,7 +3666,7 @@ lpfc_bsg_issue_read_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		pmboxq->u.mb.mbxStatus = MBXERR_ERROR;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
-			"2939 SLI_CONFIG ext-buffer rd maibox command "
+			"2939 SLI_CONFIG ext-buffer rd mailbox command "
 			"complete, ctxState:x%x, mbxStatus:x%x\n",
 			phba->mbox_ext_buf_ctx.state, pmboxq->u.mb.mbxStatus);
 
@@ -3706,7 +3706,7 @@ lpfc_bsg_issue_write_mbox_ext_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 		pmboxq->u.mb.mbxStatus = MBXERR_ERROR;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
-			"2940 SLI_CONFIG ext-buffer wr maibox command "
+			"2940 SLI_CONFIG ext-buffer wr mailbox command "
 			"complete, ctxState:x%x, mbxStatus:x%x\n",
 			phba->mbox_ext_buf_ctx.state, pmboxq->u.mb.mbxStatus);
 
@@ -3988,12 +3988,12 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 	if ((rc == MBX_SUCCESS) || (rc == MBX_BUSY)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 				"2947 Issued SLI_CONFIG ext-buffer "
-				"maibox command, rc:x%x\n", rc);
+				"mailbox command, rc:x%x\n", rc);
 		return SLI_CONFIG_HANDLED;
 	}
 	lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 			"2948 Failed to issue SLI_CONFIG ext-buffer "
-			"maibox command, rc:x%x\n", rc);
+			"mailbox command, rc:x%x\n", rc);
 	rc = -EPIPE;
 
 job_error:
@@ -4147,12 +4147,12 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba, struct bsg_job *job,
 		if ((rc == MBX_SUCCESS) || (rc == MBX_BUSY)) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 					"2955 Issued SLI_CONFIG ext-buffer "
-					"maibox command, rc:x%x\n", rc);
+					"mailbox command, rc:x%x\n", rc);
 			return SLI_CONFIG_HANDLED;
 		}
 		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 				"2956 Failed to issue SLI_CONFIG ext-buffer "
-				"maibox command, rc:x%x\n", rc);
+				"mailbox command, rc:x%x\n", rc);
 		rc = -EPIPE;
 		goto job_error;
 	}
@@ -4492,12 +4492,12 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struct bsg_job *job,
 		if ((rc == MBX_SUCCESS) || (rc == MBX_BUSY)) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 					"2969 Issued SLI_CONFIG ext-buffer "
-					"maibox command, rc:x%x\n", rc);
+					"mailbox command, rc:x%x\n", rc);
 			return SLI_CONFIG_HANDLED;
 		}
 		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
 				"2970 Failed to issue SLI_CONFIG ext-buffer "
-				"maibox command, rc:x%x\n", rc);
+				"mailbox command, rc:x%x\n", rc);
 		rc = -EPIPE;
 		goto job_error;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 060f0e2f6ff5..dc4334fa41bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5117,7 +5117,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
 					LOG_DISCOVERY,
-					"2772 Issue FCF rediscover mabilbox "
+					"2772 Issue FCF rediscover mailbox "
 					"command failed, fail through to FCF "
 					"dead event\n");
 			spin_lock_irq(&phba->hbalock);
@@ -5209,7 +5209,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 				lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
 						LOG_DISCOVERY,
 						"2774 Issue FCF rediscover "
-						"mabilbox command failed, "
+						"mailbox command failed, "
 						"through to CVL event\n");
 				spin_lock_irq(&phba->hbalock);
 				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
-- 
2.17.0

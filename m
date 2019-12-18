Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370F5C2D0C3
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 08:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A3521D7D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 08:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfLRInW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 03:43:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56981 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRInV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 03:43:21 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ihUvO-00038G-Ne; Wed, 18 Dec 2019 08:43:18 +0000
From:   Colin King <colin.king@canonical.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix spelling mistakes of asynchronous
Date:   Wed, 18 Dec 2019 08:43:01 +0000
Message-Id: <20191218084301.627555-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes of asynchronous in a lpfc_printf_log
message and comments. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6298b1729098..6a04fdb3fbf2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5883,7 +5883,7 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
 			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-					"1804 Invalid asynchrous event code: "
+					"1804 Invalid asynchronous event code: "
 					"x%x\n", bf_get(lpfc_trailer_code,
 					&cq_event->cqe.mcqe_cmpl));
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c82b5792da98..625c046ac4ef 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8555,7 +8555,7 @@ lpfc_sli4_async_mbox_unblock(struct lpfc_hba *phba)
 	psli->sli_flag &= ~LPFC_SLI_ASYNC_MBX_BLK;
 	spin_unlock_irq(&phba->hbalock);
 
-	/* wake up worker thread to post asynchronlous mailbox command */
+	/* wake up worker thread to post asynchronous mailbox command */
 	lpfc_worker_wake_up(phba);
 }
 
@@ -8823,7 +8823,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 		return rc;
 	}
 
-	/* Now, interrupt mode asynchrous mailbox command */
+	/* Now, interrupt mode asynchronous mailbox command */
 	rc = lpfc_mbox_cmd_check(phba, mboxq);
 	if (rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
@@ -13112,11 +13112,11 @@ lpfc_cq_event_setup(struct lpfc_hba *phba, void *entry, int size)
 }
 
 /**
- * lpfc_sli4_sp_handle_async_event - Handle an asynchroous event
+ * lpfc_sli4_sp_handle_async_event - Handle an asynchronous event
  * @phba: Pointer to HBA context object.
  * @cqe: Pointer to mailbox completion queue entry.
  *
- * This routine process a mailbox completion queue entry with asynchrous
+ * This routine process a mailbox completion queue entry with asynchronous
  * event.
  *
  * Return: true if work posted to worker thread, otherwise false.
@@ -13270,7 +13270,7 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
  * @cqe: Pointer to mailbox completion queue entry.
  *
  * This routine process a mailbox completion queue entry, it invokes the
- * proper mailbox complete handling or asynchrous event handling routine
+ * proper mailbox complete handling or asynchronous event handling routine
  * according to the MCQE's async bit.
  *
  * Return: true if work posted to worker thread, otherwise false.
-- 
2.24.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD69C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 07:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3926127A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 07:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFHHZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 03:25:04 -0400
Received: from m12-17.163.com ([220.181.12.17]:46417 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhFHHZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 03:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=lXAG6
        vCftIk6Ip/UkivpNpsxciXf87u+LUWOlsCSk0o=; b=CoaKPJGZm9VDPyPxwu3sy
        brDVKLD7Cj2Q7lJhQEaGd2E75KDdIizN7sM7mAZprmXHhImKAJppgVTVfU5GA1Av
        TM24JckQwcAQy3Xmm3zmLNYrE6XVZuluUQv723bM2tx77VNcTn2kZS+FDycONBhe
        z+Q/dXqeiIIWyWeXkegTAA=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowADH5ZW5Gr9gr0h06A--.64881S2;
        Tue, 08 Jun 2021 15:22:34 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_nvmet: deleted the repeated word
Date:   Tue,  8 Jun 2021 15:21:33 +0800
Message-Id: <20210608072133.272091-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowADH5ZW5Gr9gr0h06A--.64881S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww1fWF4kWrWDZw4kCFyDZFb_yoW8JFW3pa
        1rCF1IvrsYkF1IkFW3Zr48ur98t3WFqFWj9a1DK345uFWrtrW7JFyxGrWDXrWrXF48Jryj
        vrsrKryjg3WDZrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b8wIgUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbi3xqrUGB0Gd-8rgAAs+
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted the repeated word 'the' and 'received' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f2d9a3580887..bf35984e58e9 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1469,7 +1469,7 @@ lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
 	if (!infop)
 		return;
 
-	/* Cycle the the entire CPU context list for every MRQ */
+	/* Cycle the entire CPU context list for every MRQ */
 	for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
 		for_each_present_cpu(j) {
 			infop = lpfc_get_ctx_list(phba, j, i);
@@ -3562,7 +3562,7 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
  * lpfc_nvme_unsol_ls_issue_abort - issue ABTS on an exchange received
  *        via async frame receive where the frame is not handled.
  * @phba: pointer to adapter structure
- * @ctxp: pointer to the asynchronously received received sequence
+ * @ctxp: pointer to the asynchronously received sequence
  * @sid: address of the remote port to send the ABTS to
  * @xri: oxid value to for the ABTS (other side's exchange id).
  **/
-- 
2.25.1



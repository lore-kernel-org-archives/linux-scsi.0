Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0FCC48BCF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 02:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA096128A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 02:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhFIC0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 22:26:01 -0400
Received: from m12-16.163.com ([220.181.12.16]:46450 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhFIC0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 22:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=5TGYv
        pzFiLqgSFjEHruR/qql6v+FgILO+nB88xoTYpg=; b=N+rdWbzH171iz/Hk5UFhE
        b+0vG+rJcMgIgvnY2lqL86i8+FQHgtsi5a9saUek/wJzidggN6dcxeAjSQ/VtYA8
        mgdmLJpFFyCAebUvUkGE4H3FQnaIyuV8LOM2sU/LM0uy1gtyy86tKDc79JRSh7dL
        TnjNkX8sHGyw2qDKvSrI4w=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowACnrVkaJsBgJslqwA--.15068S2;
        Wed, 09 Jun 2021 10:23:23 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_init: deleted these repeated words
Date:   Wed,  9 Jun 2021 10:22:21 +0800
Message-Id: <20210609022221.306132-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowACnrVkaJsBgJslqwA--.15068S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFWfGw1Dtw1UZw4DtFy7ZFb_yoW5WFy5pF
        WxG3W7Wr1kGF4IqFyfCw4ruF1av3yrXF9IyFWIgw1furWFkF97tFyxtFyUJry5JF40v3ya
        vr92kr48W3WUJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b1zV8UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBERusUFaEEqRoLAAAsW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'the', 'using' and 'be' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5f018d02bf56..f6c26342ad69 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5105,7 +5105,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	bf_set(lpfc_mbx_read_top_link_spd, la,
 	       (bf_get(lpfc_acqe_link_speed, acqe_link)));
 
-	/* Fake the the following irrelvant fields */
+	/* Fake the following irrelvant fields */
 	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
 	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
 	bf_set(lpfc_mbx_read_top_il, la, 0);
@@ -5905,7 +5905,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
 				spin_unlock_irq(&phba->hbalock);
 				/*
-				 * Last resort will be re-try on the
+				 * Last resort will be re-try on
 				 * the current registered FCF entry.
 				 */
 				lpfc_retry_pport_discovery(phba);
@@ -10829,7 +10829,7 @@ lpfc_find_cpu_handle(struct lpfc_hba *phba, uint16_t id, int match)
 	for_each_present_cpu(cpu) {
 		cpup = &phba->sli4_hba.cpu_map[cpu];
 
-		/* If we are matching by EQ, there may be multiple CPUs using
+		/* If we are matching by EQ, there may be multiple CPUs
 		 * using the same vector, so select the one with
 		 * LPFC_CPU_FIRST_IRQ set.
 		 */
@@ -11017,7 +11017,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			/* Mark CPU as IRQ not assigned by the kernel */
 			cpup->flag |= LPFC_CPU_MAP_UNASSIGN;
 
-			/* If so, find a new_cpup thats on the the SAME
+			/* If so, find a new_cpup thats on the SAME
 			 * phys_id as cpup. start_cpu will start where we
 			 * left off so all unassigned entries don't get assgined
 			 * the IRQ of the first entry.
@@ -11868,7 +11868,7 @@ lpfc_unset_hba(struct lpfc_hba *phba)
  * I/Os every 30 seconds, log error message, and wait forever. Only when
  * all XRI exchange busy complete, the driver unload shall proceed with
  * invoking the function reset ioctl mailbox command to the CNA and the
- * the rest of the driver unload resource release.
+ * rest of the driver unload resource release.
  **/
 static void
 lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
@@ -12046,7 +12046,7 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phba)
  * This function is called in the SLI4 code path to read the port's
  * sli4 capabilities.
  *
- * This function may be be called from any context that can block-wait
+ * This function may be called from any context that can block-wait
  * for the completion.  The expectation is that this routine is called
  * typically from probe_one or from the online routine.
  **/
-- 
2.25.1



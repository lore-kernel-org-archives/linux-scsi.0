Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20939C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E80613B3
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFJGND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:13:03 -0400
Received: from m12-11.163.com ([220.181.12.11]:54485 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhFJGNB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 02:13:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8XC0j
        fht6Z+Lvl0S0+t3gBIOx84dXd8WqX16zzntdSg=; b=TAAQZ9lKozuR18P0BfW2F
        c7lQxrEtvpOWH5vidYptb8OInLl2hMrxaTSHwH2UyDnE5XJjYrGUQidk9rNyF2jG
        wtnHglig11QHF7fJqVBhdh4eDSq0xc9x28p0DWk6zS/8jKRg4LjBtzJLVmS0d/nC
        paG7bIo8RFNg3NxJxAkZfM=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowACXElXOrMFgJxPdhA--.21870S2;
        Thu, 10 Jun 2021 14:10:23 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH v2] scsi: lpfc: lpfc_init: deleted these repeated words
Date:   Thu, 10 Jun 2021 14:09:21 +0800
Message-Id: <20210610060921.67172-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowACXElXOrMFgJxPdhA--.21870S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww1xAr4fCF1DGr45tFyUGFg_yoW8JFWfpF
        WxGa4Uur1ktF4xtF4fJrs5Z3W3tayrWa9ayay293Z7urWFqFZ7tryFqFWUWry5JF4jyr9x
        Xr92y3yDW3WUJFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b8T5LUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiEQ+tUF7+3qNLRAAAsx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'the', 'using' and 'be' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
v2: Fix these typos
Change 'irrelvant' to 'irrelevant'.
Change 'will be re-try' to 'will be retried'.

 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 932c6bdb8c40..bba1ecdfa501 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5094,7 +5094,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	bf_set(lpfc_mbx_read_top_link_spd, la,
 	       (bf_get(lpfc_acqe_link_speed, acqe_link)));
 
-	/* Fake the following irrelvant fields */
+	/* Fake the following irrelevant fields */
 	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
 	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
 	bf_set(lpfc_mbx_read_top_il, la, 0);
@@ -5894,7 +5894,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
 				spin_unlock_irq(&phba->hbalock);
 				/*
-				 * Last resort will be re-try on
+				 * Last resort will be retried on
 				 * the current registered FCF entry.
 				 */
 				lpfc_retry_pport_discovery(phba);
-- 
2.25.1


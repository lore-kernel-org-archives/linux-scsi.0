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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A6CC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62C461352
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhFIHEt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:04:49 -0400
Received: from m12-17.163.com ([220.181.12.17]:44703 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236977AbhFIHEn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 03:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=1DIJp
        HP+Eol0S9hpb7lABrWGpCIi+rnoAxnOQ9OdNvQ=; b=Ni9HIpxYDueZW94cD2MYO
        o6m91F52K88gBCuWSdU8/1G89qFWyyM0qrCPRk7pZOHBsHTExaDc5qPVhLZpK8HC
        oQz+7sQeklqMYl8dWOANunwzuanrzmBMOmkzWLlX6UxRALIGUTjoJkp7m7mI/MZK
        hOUOOWvdY69/uPOUY4ENdk=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowABnTXVyZ8Bgitlc6Q--.23071S2;
        Wed, 09 Jun 2021 15:02:10 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_hbadisc: deleted these repeated words
Date:   Wed,  9 Jun 2021 15:01:13 +0800
Message-Id: <20210609070113.443914-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowABnTXVyZ8Bgitlc6Q--.23071S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF4UXr47tr1DuFy3Zw47Arb_yoW8WFWDpr
        Z7KF1UAr1vkF42k3W3AryUZF90k3s3WFZFyF4qy345WrWrJrW0qr10q34fJay5WF4Fvw1q
        vFsFkF9xua1kZrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b8b1bUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiLxKsUFUMY37LWgAAsU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'the' and 'random' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f5a898c2c904..40a5a7f02fa2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1837,7 +1837,7 @@ lpfc_check_pending_fcoe_event(struct lpfc_hba *phba, uint8_t unreg_fcf)
  * use through a sequence of @fcf_cnt eligible FCF records with equal
  * probability. To perform integer manunipulation of random numbers with
  * size unit32_t, the lower 16 bits of the 32-bit random number returned
- * from prandom_u32() are taken as the random random number generated.
+ * from prandom_u32() are taken as the random number generated.
  *
  * Returns true when outcome is for the newly read FCF record should be
  * chosen; otherwise, return false when outcome is for keeping the previously
@@ -2138,7 +2138,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the the round robin slection for the particular priority level
+ * flag so the round robin slection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
-- 
2.25.1



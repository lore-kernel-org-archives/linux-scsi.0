Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1AC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 05:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF390613F1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 05:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhFJFuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 01:50:10 -0400
Received: from m12-17.163.com ([220.181.12.17]:36977 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJFuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 01:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=31k3i
        V9GoasuZDit4YgL+Ut81SpGX7iPAJg3QTv7z00=; b=Mo7K0kJv/4BfYVLN3HDww
        /FYAxQtQzsmXwyJPE/FQ72z5+qYiLmF7YjtbD1zvFU8ZnF26zqDiDGmV0mDOyF4t
        l1LMqedA1jD+YPbkiKwjWnxkqY39QGYDesfiR2aMUTebzR0q9Kw39WEc3G4DohoC
        7gMPSn3J3nzdHPkxS2J4DY=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowAB3UGhtp8FgwkcZ6g--.41572S2;
        Thu, 10 Jun 2021 13:47:26 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH v2] scsi: lpfc: lpfc_hbadisc: deleted these repeated words
Date:   Thu, 10 Jun 2021 13:46:24 +0800
Message-Id: <20210610054624.51800-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAB3UGhtp8FgwkcZ6g--.41572S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF43Ww48Kw45Jr4fGr48JFb_yoWkGrX_WF
        48ZF1xJw4kAFZ7AFy7Xr13Zr92q3y5ZFn7C34qqryrXr4DXF4DArs09rWUZryrurZFqa43
        C3Z3WFyFkw43WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU57CztUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiHQ6tUFSIrHiv9gAAs-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'the' and 'random' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
v2: fix a typo
change 'slection' to 'selection'.

 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 8ade5a520897..d38d721b2b59 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2130,7 +2130,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the round robin slection for the particular priority level
+ * flag so the round robin selection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
-- 
2.25.1



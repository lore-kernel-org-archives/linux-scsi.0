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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4255CC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2691161375
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 07:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhFIHNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:13:09 -0400
Received: from m12-12.163.com ([220.181.12.12]:42063 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234969AbhFIHNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 03:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ZhXBU
        Uhb8IEEd5BfnTokZalclItqpdzTrKmB683qQ6k=; b=oSVvRZmA5/8pTz33ZVDB+
        vlpYKz2Sp4teJUgS2jGA4+dOlL8ayzisaM4tjHbHE9gGblgBFtuFTten52dTdPUA
        IVw2EJaiELoyvOALvdWTDqHENyCVFHYoNLdPqz4gaRItkwiBhnk1QVaNAo9Pu4tq
        5+39TJ8JFc4bDGlwhIZs7M=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowADnuCmsZcBgWI2WIw--.37107S2;
        Wed, 09 Jun 2021 14:54:36 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_bsg: deleted these repeated words
Date:   Wed,  9 Jun 2021 14:53:39 +0800
Message-Id: <20210609065339.428697-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowADnuCmsZcBgWI2WIw--.37107S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww1fWFy3uFW3XFWrWF48Zwb_yoW8XrWfpF
        W8Cay7CrykXa1kKa4fA34UZ3s0va97JFy7CFs0v3s5ZFWUJrykXFWrtr1UXFWUWFWv9r9I
        qrs3KrWDuF1qvrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bbZXrUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiSg2sUFPAOoUs4AAAsb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted these repeated words 'the' and 'is' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 38cfe1bc6a4d..08be16e7a60a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1766,7 +1766,7 @@ lpfc_bsg_diag_mode_exit(struct lpfc_hba *phba)
  * This function is responsible for placing an sli3  port into diagnostic
  * loopback mode in order to perform a diagnostic loopback test.
  * All new scsi requests are blocked, a small delay is used to allow the
- * scsi requests to complete then the link is brought down. If the link is
+ * scsi requests to complete then the link is brought down. If the link
  * is placed in loopback mode then scsi requests are again allowed
  * so the scsi mid-layer doesn't give up on the port.
  * All of this is done in-line.
@@ -5883,7 +5883,7 @@ lpfc_bsg_timeout(struct bsg_job *job)
 		return -EIO;
 
 	/* if job's driver data is NULL, the command completed or is in the
-	 * the process of completing.  In this case, return status to request
+	 * process of completing.  In this case, return status to request
 	 * so the timeout is retried.  This avoids double completion issues
 	 * and the request will be pulled off the timer queue when the
 	 * command's completion handler executes.  Otherwise, prevent the
-- 
2.25.1



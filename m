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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA727C4743D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B341261285
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhFIDLQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:11:16 -0400
Received: from m12-18.163.com ([220.181.12.18]:40825 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhFIDLP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 23:11:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=egJWT
        JFWyhEMc8/aZJ337yvOourJR6vCzbSA2WETxL4=; b=Tks/k2xRjAVB6UfWKxipY
        HMo4DnxzkRLwOM8OaN6VyyEIEb7Wog3bHphYxI95FW4lu03CSO3l7bGkEIg8ahkJ
        3cDcqEigN5V+n+p8gsia0OG2F+RDfLMaK85i8yu+gF5PNVd+AG7w9j9z/dk1SJ/u
        XbjWcF/zCeqZMGevUS8TfU=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowADH1Ai3MMBgKSKAoQ--.801S2;
        Wed, 09 Jun 2021 11:08:39 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_nportdisc: deleted the repeated word
Date:   Wed,  9 Jun 2021 11:07:42 +0800
Message-Id: <20210609030742.336713-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADH1Ai3MMBgKSKAoQ--.801S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruryDKw4rAr4rCr1ruF4kWFg_yoWfAFb_uF
        WIvr13Xr47CFW8ua4xCr4xA3sFyr45Zwn2k3ZayFWfWr18WF1UXFWDZr12qrW8CrsrXa47
        Xa1jqr9Ykw45XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5YksDUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/xtbBERisUFaEEqUCigAAsY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted the repeated word 'on' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index bb4e65a32ecc..a2251e5dda7c 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -235,7 +235,7 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-	/* Add to abort_list on on NDLP match. */
+	/* Add to abort_list on NDLP match. */
 		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
 			list_add_tail(&iocb->dlist, &abort_list);
 	}
-- 
2.25.1



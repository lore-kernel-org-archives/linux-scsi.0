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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0DFC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB6476136D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhFIJrf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:47:35 -0400
Received: from m12-18.163.com ([220.181.12.18]:43127 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhFIJrf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 05:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=PfkIz
        4ovk4dy9HRIfmqO/s1x5e2i0M9m7os9gzqEq3Y=; b=XJ7XoA7zFJJPlCl200re4
        ebYeaRimCGZyETww06zOGz6IA6lGuTQjXJ3StiHzbBrFL2finGBU0CJngglefsjO
        fayRIee4wLvAq/gQKS7FAs9uWKzPAPR3WcD53+wIpz+ZFKF+HFgTDSjkxyefpkQu
        w7bPXeBDaU7cMG0k7eGy84=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowABHTualjcBgLpu0oQ--.5110S2;
        Wed, 09 Jun 2021 17:45:10 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_nvme: Removed unnecessary 'return'
Date:   Wed,  9 Jun 2021 17:44:13 +0800
Message-Id: <20210609094413.596196-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABHTualjcBgLpu0oQ--.5110S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWxGrWxGF4fGF18Wry7trb_yoWxurgE9a
        1kZFyfXaykCa1kZFyUJr4fZ34qyr4rZrn2kF1qqryfur4DWa1UWrWUZ345WryUArs8X3Zr
        W3Z5Zr40yr15KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnED7PUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiHQasUFSIrGxbRAAAsk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 78171ef77c7e..5daad2caf891 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1871,7 +1871,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 out_unlock:
 	spin_unlock(&lpfc_nbuf->buf_lock);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
-	return;
 }
 
 /* Declare and initialization an instance of the FC NVME template. */
-- 
2.25.1



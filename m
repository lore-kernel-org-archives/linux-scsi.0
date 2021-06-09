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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0A9C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 05:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2407261351
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 05:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhFIFyi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 01:54:38 -0400
Received: from m12-12.163.com ([220.181.12.12]:35121 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhFIFyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Jun 2021 01:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tLIZd
        92qh67BbrTqsD9RiSadHJtSHsVSduEWRoYIY9Q=; b=HSOEiSOwpIt2T+uX+ETs1
        gIUX8rdt8rT6ynVG8TkAhV3S/bV7Yi2u1jNaJ0+BgVm8lyIknAzTG1AFJuMddG7w
        7LrN4if130csPMWK9gfxhNOkNEvR9GKH1Targ7npi7hqX+Qfxt/dT3q5sdIXi5fE
        kT1q+su3AY2OlS/H2AxWaA=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowAC3uwcjM8Bgr3d7Iw--.33312S2;
        Wed, 09 Jun 2021 11:19:00 +0800 (CST)
From:   lijian_8010a29@163.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: lpfc: lpfc_ct: deleted the repeated word
Date:   Wed,  9 Jun 2021 11:18:03 +0800
Message-Id: <20210609031803.351918-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAC3uwcjM8Bgr3d7Iw--.33312S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw4DuFyDXw1xuFyftryDAwb_yoW3XFg_ur
        48Zr12qw4qka1qvFy7JrW3Z3sFkrWrXFn2k3Z0qr93ur18Xr4UXrWqqry3ury8Ar98XFnr
        C3WkXr1Fyw45tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5YksDUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiLwSsUFUMY3wgPwAAsO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

deleted the repeated word 'in' in the comments.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 3bbefa225484..450f3a3fa911 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -909,7 +909,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint8_t fc4_type,
 
 	}
 
-	/* All GID_FT entries processed.  If the driver is running in
+	/* All GID_FT entries processed.  If the driver is running
 	 * in target mode, put impacted nodes into recovery and drop
 	 * the RPI to flush outstanding IO.
 	 */
-- 
2.25.1



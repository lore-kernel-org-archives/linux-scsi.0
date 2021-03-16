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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7648C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 02:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939BB64F9F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 02:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhCPCxP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 22:53:15 -0400
Received: from m12-17.163.com ([220.181.12.17]:38646 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230354AbhCPCw6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 22:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=egFsm
        aRqUjZO872aAQH+LJ0vnSQjRszS/d+CKYnmCRE=; b=RGHdOM4q4tQyqEIRPADEp
        +EYEHroVEW8THI2YN2w9kCQXk3DX909pdAC8xKYwAg636nahv2htgwfC2yJ5EPW7
        p9armJ2bJrOM3SsTcWje9nKNlBIqWLClyVyCJMU0m8ar7OQcsV5ucdGtqJAUjTBl
        d8VWxU2xk/ckbWTArvHfz4=
Received: from COOL-20200916KH.ccdomain.com (unknown [218.94.48.178])
        by smtp13 (Coremail) with SMTP id EcCowAAHBrNHHVBgCSL4qA--.2520S2;
        Tue, 16 Mar 2021 10:52:01 +0800 (CST)
From:   qiumibaozi_1@163.com
To:     James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganjisheng <ganjisheng@yulong.com>
Subject: [PATCH] Fix spelling typo of conditions
Date:   Tue, 16 Mar 2021 10:51:41 +0800
Message-Id: <20210316025141.824-1-qiumibaozi_1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAAHBrNHHVBgCSL4qA--.2520S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr48AF13GFWDuw4UCw4kZwb_yoW3XrX_Ar
        4vqw1IgrW8A34xAr1UCanxZr92vw4qg3Wv9ws0vF93Zry5ZrnruFyjqr1Yqr15Way5AFyD
        Ary7XFnYy3ZrtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5BVbDUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5tlxzxxedr6xjbr6il2tof0z/xtbBFBFX2FaD+s7ztAAAss
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ganjisheng <ganjisheng@yulong.com>

Signed-off-by: ganjisheng <ganjisheng@yulong.com>
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 3242ff6..4fd91f8 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -980,7 +980,7 @@ struct Scsi_Host *
 			NCR_700_set_tag_neg_state(SCp->device,
 						  NCR_700_FINISHED_TAG_NEGOTIATION);
 			
-		/* check for contingent allegiance contitions */
+		/* check for contingent allegiance conditions */
 		if(status_byte(hostdata->status[0]) == CHECK_CONDITION ||
 		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
 			struct NCR_700_command_slot *slot =
-- 
1.9.1



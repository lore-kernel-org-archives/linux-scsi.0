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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C485C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F001661208
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFHCkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:40:51 -0400
Received: from m12-18.163.com ([220.181.12.18]:35340 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhFHCkt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Jun 2021 22:40:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KPaZ2
        ipkRHFS/Qdo7wA+7Z2o1qZRctkpCKAxDv2WSXc=; b=jjCXVK8AebwDnUMar5yCL
        qU6UTBL4vO09JMF3Ko4faZLyV99iWgTPwK027AYCq0ukU8TUy3dYBDIvRZXu5I+X
        GhiYx1KUUwHHSPIjsksEQ1ZS8YU0E0LSGSoZf+nnPKheVHSmlCh+AvaWUpvevkHZ
        TkHpsu58MivFR4nKE/ntb8=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowADX3s4g2L5gBJugoA--.55130S2;
        Tue, 08 Jun 2021 10:38:25 +0800 (CST)
From:   lijian_8010a29@163.com
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: [PATCH] scsi: aacraid: aachba: Removed unnecessary 'return'
Date:   Tue,  8 Jun 2021 10:37:28 +0800
Message-Id: <20210608023728.240466-1-lijian_8010a29@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowADX3s4g2L5gBJugoA--.55130S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFWxGrWxGF4fGF18JFWkJFb_yoWxtFg_Ga
        1aqa4xGryUCFWI9ryxCw13ZFyqyayrZr4jkFsYqrW3ZrWUZ3y8Ar40vFnrZryUGF4UZ3Zr
        W3WUZF1qkw1kKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnKg43UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5olmxttqbyiikqdsmqqrwthudrp/1tbiRQGrUFl92ACEQQAAsG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: lijian <lijian@yulong.com>

Removed unnecessary 'return'.

Signed-off-by: lijian <lijian@yulong.com>
---
 drivers/scsi/aacraid/aachba.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 46b8dffce2dd..a84564a53276 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -675,7 +675,6 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 	callback = (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
 	scsicmd->SCp.ptr = NULL;
 	(*callback)(scsicmd);
-	return;
 }
 
 static void _aac_probe_container1(void * context, struct fib * fibptr)
-- 
2.25.1



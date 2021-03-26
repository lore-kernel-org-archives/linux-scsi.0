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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA30C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1BF61A3F
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCZDFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 23:05:09 -0400
Received: from m12-12.163.com ([220.181.12.12]:51966 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhCZDEt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 23:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2G9Da
        PJPfkOI0yPguBZC5/0YHfn9fG2m5T4OVfNjZK4=; b=EvEO5dNPnImqgFJ7PIFhP
        Ak00NJHykiP35AHFdY3kpgAceHSq+qWd23X0lEIIduWm8qiV396OHck4XYXXJeDZ
        dgngsFP7775oyMnEwuhnR6l9QZ/GKoKbl4pAVIlHpWjPxoo6xMJH96vp2lktEW4V
        4uPRhhM50YOZjrPInFMc/4=
Received: from COOL-20200916KH.ccdomain.com (unknown [218.94.48.178])
        by smtp8 (Coremail) with SMTP id DMCowABHzJgvT11gCkD1WQ--.16948S2;
        Fri, 26 Mar 2021 11:04:19 +0800 (CST)
From:   qiumibaozi_1@163.com
To:     willy@infradead.org, hare@suse.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganjisheng <ganjisheng@yulong.com>
Subject: [PATCH 6/6] Fix spelling typo of is
Date:   Fri, 26 Mar 2021 11:04:12 +0800
Message-Id: <20210326030412.1656-1-qiumibaozi_1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABHzJgvT11gCkD1WQ--.16948S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr48AF13GFWDtF4rXr45GFg_yoW3Grb_Ga
        yv9F92vw48Ga1IkF1rXF40vr9F9r4Uua1kuF1SqrnavryrXw47XFsaqr18Aa1UJw4fZ3s8
        Xa43X3yayw12gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYBMKJUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5tlxzxxedr6xjbr6il2tof0z/1tbiLRRh2FSIlaiXegAAsM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ganjisheng <ganjisheng@yulong.com>

Signed-off-by: ganjisheng <ganjisheng@yulong.com>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ec56278..e9516de 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1812,7 +1812,7 @@
  * Field naming convention:
  *
  *  *_able indicates both whether a feature should be enabled or disabled
- *  and whether a device isi capable of the feature. At initialization
+ *  and whether a device is capable of the feature. At initialization
  *  this field may be set, but later if a device is found to be incapable
  *  of the feature, the field is cleared.
  */
-- 
1.9.1



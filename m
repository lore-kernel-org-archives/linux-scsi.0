Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1747C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78AA664F78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhBCBuk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:50:40 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:38016 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230369AbhBCBuj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:50:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNiznmg_1612316993;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNiznmg_1612316993)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 09:49:53 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     bootc@bootc.net
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi: target: remove unneeded semicolon
Date:   Wed,  3 Feb 2021 09:49:52 +0800
Message-Id: <1612316992-71443-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/target/sbp/sbp_target.c:1009:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/target/sbp/sbp_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9f..2a6165f 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1006,7 +1006,7 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 			agent->state = AGENT_STATE_SUSPENDED;
 
 		spin_unlock_bh(&agent->lock);
-	};
+	}
 }
 
 static struct sbp_target_agent *sbp_target_agent_register(
-- 
1.8.3.1


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10190CDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 03:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjJQDJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 23:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQDJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 23:09:20 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78AC93;
        Mon, 16 Oct 2023 20:09:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VuLNmRW_1697512154;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VuLNmRW_1697512154)
          by smtp.aliyun-inc.com;
          Tue, 17 Oct 2023 11:09:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: target: core: Fix one kernel-doc comment
Date:   Tue, 17 Oct 2023 11:09:13 +0800
Message-Id: <20231017030913.89973-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix one kernel-doc comment to silence the warnings:
drivers/target/target_core_transport.c:1930: warning: Excess function parameter 'cmd' description in 'target_submit'
drivers/target/target_core_transport.c:1930: warning: Function parameter or member 'se_cmd' not described in 'target_submit'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6844
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c81def3c96df..670cfb7bd426 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1921,7 +1921,7 @@ static void target_queue_submission(struct se_cmd *se_cmd)
 
 /**
  * target_submit - perform final initialization and submit cmd to LIO core
- * @cmd: command descriptor to submit
+ * @se_cmd: command descriptor to submit
  *
  * target_submit_prep or something similar must have been called on the cmd,
  * and this must be called from process context.
-- 
2.20.1.7.g153144c


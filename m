Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358D4C32774
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 05:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbiHWFbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Aug 2022 01:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiHWFbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2022 01:31:52 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED15D0E4;
        Mon, 22 Aug 2022 22:31:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VN09ZB7_1661232704;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VN09ZB7_1661232704)
          by smtp.aliyun-inc.com;
          Tue, 23 Aug 2022 13:31:48 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: qlogicpti: Remove unneeded semicolon
Date:   Tue, 23 Aug 2022 13:31:31 +0800
Message-Id: <20220823053131.125335-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No functional modification involved.

./drivers/scsi/qlogicpti.c:1151:3-4: Unneeded semicolon.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1942
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5bddfe0233b2..a58c7c7b1a17 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1148,7 +1148,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
-- 
2.20.1.7.g153144c


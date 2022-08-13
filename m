Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BDDC19F2D
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Aug 2022 15:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbiHMPm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Aug 2022 11:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239808AbiHMPmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2022 11:42:25 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3162AE0F;
        Sat, 13 Aug 2022 08:42:22 -0700 (PDT)
X-QQ-mid: bizesmtp80t1660405334tsi3ek7w
Received: from localhost.localdomain ( [110.188.55.240])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 13 Aug 2022 23:42:06 +0800 (CST)
X-QQ-SSF: 0100000000200080H000B00A0000020
X-QQ-FEAT: RLrSOnjbvYFimqIUxgUbOUJaN9Cl3aXxwvbkuX2JNSby2DOHQdBAEugFvxU8D
        QkBnyMa9ky+3xqsSqyLvcsE8mSgUsItFRKoVRXE3ZmaqRsoaK6wU1wTUjx6GhXlmA5H0nNc
        g5oc+RXubY7Hfg9+Pz9X3HxMDA7uSOyueJjXvOeX+905Kfk/0+he7IRdL2dEBXa/jeJSfqA
        aNKCue5fpLygOM/7bhpPWsSgmScQY37vny+7g1AJmqHg5xj8EpFeMIRW+iIIFEJ0UvuJ5/f
        7MmT5HRK7t8/2WGVg4Sua/hn6++WgF2+5sayxl9P1WCBheBVzLzVSSs4J+hdr01jY84vrSZ
        iqkcNESvSyzzVopgzyfUT0o4o2Q/u7ynNKA2y4A9LSqE4kQp0Ubd9rtnyqbG8q+ediv7NZ5
X-QQ-GoodBg: 0
From:   min tang <tangmin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        min tang <tangmin@cdjrlc.com>
Subject: [PATCH] scsi: qlogicpti: Unneeded semicolon
Date:   Sat, 13 Aug 2022 23:41:54 +0800
Message-Id: <20220813154154.5074-1-tangmin@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no semicolon after '}' in line 1152.

Signed-off-by: min tang <tangmin@cdjrlc.com>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 57f2f4135a06..59c82d740139 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1149,7 +1149,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
-- 
2.17.1


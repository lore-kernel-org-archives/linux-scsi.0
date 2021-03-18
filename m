Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAA4C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7D364F10
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 09:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhCRJUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 05:20:08 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:41767 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhCRJTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 05:19:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0USPiPP1_1616059157;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0USPiPP1_1616059157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Mar 2021 17:19:28 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: aha1542: remove unneeded semicolon
Date:   Thu, 18 Mar 2021 17:19:15 +0800
Message-Id: <1616059155-52449-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/scsi/aha1542.c:569:2-3: Unneeded semicolon.
./drivers/scsi/aha1542.c:554:2-3: Unneeded semicolon.
./drivers/scsi/aha1542.c:519:2-3: Unneeded semicolon.
./drivers/scsi/aha1542.c:508:3-4: Unneeded semicolon.
./drivers/scsi/aha1542.c:407:2-3: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/aha1542.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 21aab9f5b117..6d4d7d60bfba 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -404,7 +404,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 						 */
 		my_done(tmp_cmd);
 		number_serviced++;
-	};
+	}
 }
 
 static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
@@ -505,7 +505,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		scsi_for_each_sg(cmd, sg, sg_count, i) {
 			any2scsi(acmd->chain[i].dataptr, sg_dma_address(sg));
 			any2scsi(acmd->chain[i].datalen, sg_dma_len(sg));
-		};
+		}
 		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
 		any2scsi(ccb[mbo].dataptr, acmd->chain_handle);
 #ifdef DEBUG
@@ -516,7 +516,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		ccb[mbo].op = 0;	/* SCSI Initiator Command */
 		any2scsi(ccb[mbo].datalen, 0);
 		any2scsi(ccb[mbo].dataptr, 0);
-	};
+	}
 	ccb[mbo].idlun = (target & 7) << 5 | direction | (lun & 7);	/*SCSI Target Id */
 	ccb[mbo].rsalen = 16;
 	ccb[mbo].linkptr[0] = ccb[mbo].linkptr[1] = ccb[mbo].linkptr[2] = 0;
@@ -551,7 +551,7 @@ static void setup_mailboxes(struct Scsi_Host *sh)
 		any2scsi(aha1542->mb[i].ccbptr,
 			 aha1542->ccb_handle + i * sizeof(struct ccb));
 		aha1542->mb[AHA1542_MAILBOXES + i].status = 0;
-	};
+	}
 	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi(mb_cmd + 2, aha1542->mb_handle);
 	if (aha1542_out(sh->io_port, mb_cmd, 5))
@@ -564,9 +564,9 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	u8 inquiry_result[3];
 	int i;
 	i = inb(STATUS(sh->io_port));
-	if (i & DF) {
+	if (i & DF)
 		i = inb(DATA(sh->io_port));
-	};
+
 	aha1542_outb(sh->io_port, CMD_RETCONF);
 	aha1542_in(sh->io_port, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
-- 
2.20.1.2432.ga663e714


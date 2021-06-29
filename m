Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B02C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 12:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B93D61DE3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 12:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhF2M5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 08:57:52 -0400
Received: from m12-17.163.com ([220.181.12.17]:33832 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233006AbhF2M5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 08:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=EXz6v
        pDzMzYn5VZ9oPlYoMts/4MVeH8md+BmGncxj50=; b=AfuDWrt2ib7K4YLeFCBcO
        zyu1788spbyi7H012DjZTzl2nOvfvaDNdvWGDDdk3yubglzw6idcN3xvMZxUtzUQ
        +rYl3b8sd++fFHgiNzJNahcZz0/myIJBQyJ1EbUypNrvEHhxoCcZ64qqhqbrh4hb
        UllmImMJAypol/YebESuoo=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowAB3n4MxGNtg_N+_+A--.31644S2;
        Tue, 29 Jun 2021 20:55:14 +0800 (CST)
From:   gushengxian <13145886936@163.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] scsi: aha1542: Remove unneeded semicolons
Date:   Tue, 29 Jun 2021 05:55:08 -0700
Message-Id: <20210629125508.728580-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAB3n4MxGNtg_N+_+A--.31644S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWF4fJr1rXw1ktF4UArWfGrg_yoW5ZFykpF
        W3G3yjyw4UtF47GrZ8AF1F9r45AFykJ34xGw1vg34fWFZ3GF1qgrZF9ryYvr9xGFZ7Wa43
        XrWFy3W7u3WUAwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jiDGOUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiyhLAg1QHMjyUSQAAsb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Remove some unneeded semicolons.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 drivers/scsi/aha1542.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 1210e61afb18..7229748a57b9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -304,7 +304,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		if (flag & SCRD)
 			printk("SCRD ");
 		printk("status %02x\n", inb(STATUS(sh->io_port)));
-	};
+	}
 #endif
 	number_serviced = 0;
 
@@ -346,7 +346,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 			if (!number_serviced)
 				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
 			return IRQ_HANDLED;
-		};
+		}
 
 		mbo = (scsi2int(mb[mbi].ccbptr) - (unsigned long)aha1542->ccb_handle) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
@@ -411,7 +411,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 						 */
 		my_done(tmp_cmd);
 		number_serviced++;
-	};
+	}
 }
 
 static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
@@ -537,7 +537,7 @@ static void setup_mailboxes(struct Scsi_Host *sh)
 		any2scsi(aha1542->mb[i].ccbptr,
 			 aha1542->ccb_handle + i * sizeof(struct ccb));
 		aha1542->mb[AHA1542_MAILBOXES + i].status = 0;
-	};
+	}
 	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi(mb_cmd + 2, aha1542->mb_handle);
 	if (aha1542_out(sh->io_port, mb_cmd, 5))
@@ -552,7 +552,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_RETCONF);
 	aha1542_in(sh->io_port, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -581,7 +581,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine DMA channel.\n");
 		return -1;
-	};
+	}
 	switch (inquiry_result[1]) {
 	case 0x40:
 		sh->irq = 15;
@@ -604,7 +604,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine IRQ level.\n");
 		return -1;
-	};
+	}
 	sh->this_id = inquiry_result[2] & 7;
 	return 0;
 }
@@ -639,7 +639,7 @@ static int aha1542_mbenable(struct Scsi_Host *sh)
 
 		if (aha1542_out(sh->io_port, mbenable_cmd, 3))
 			goto fail;
-	};
+	}
 	while (0) {
 fail:
 		shost_printk(KERN_ERR, sh, "Mailbox init failed\n");
@@ -657,7 +657,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_INQUIRY);
 	aha1542_in(sh->io_port, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -676,7 +676,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	if (inquiry_result[0] == 0x43) {
 		shost_printk(KERN_INFO, sh, "Emulation mode not supported for AHA-1740 hardware, use aha1740 driver instead.\n");
 		return 1;
-	};
+	}
 
 	/*
 	 * Always call this - boards that do not support extended bios translation
-- 
2.25.1



Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88652C4338F
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 10:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC07603E7
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 10:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhHGK4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 06:56:45 -0400
Received: from smtpbg704.qq.com ([203.205.195.105]:33057 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231687AbhHGK4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 06:56:44 -0400
X-QQ-mid: bizesmtp41t1628333771tok4ud4z
Received: from localhost.localdomain (unknown [125.69.42.194])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sat, 07 Aug 2021 18:56:10 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: Rrz2csB1TU0Qwsk/qlXbx4vcERuTtEo3P+PTX+6ijfugqOkKyBpVs+cDPGAcT
        PrKQvolgJ1MLaQdWeIQWbQURTHoc9bM3bahOktDStKRWr6ooBTl4s2k5hsIEmbXlWEa//Z9
        jJDi+B2Bu7yOkZRFvOl7qO0xf5Y6Lr00hRr9QeRKeadgZTkcU3hFVKwLOS74e92vjpIGtv+
        zc1lI6I9iGzUqMIRBnQnkrFsNo1a0FEgUxxy0iFu1gpXcc507SBhnAGdQ75vNTTlMihgYh2
        kZ9lUwZ7hyKIvfhba9Mrs4GMPFeVM/sk7uTdhPEgi52fhipmRAI/olH1pUujSO5X5ENHGC5
        XQ6CY7n
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] scsi: aha1542: Remove unneeded semicolon
Date:   Sat,  7 Aug 2021 18:55:25 +0800
Message-Id: <20210807105525.192240-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The semicolon after a code block bracket is unneeded in C. Thus, we can
remove the redundant semicolon from the code safely.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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
2.32.0




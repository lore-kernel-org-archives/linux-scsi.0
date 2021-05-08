Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AC4C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 09:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44AB8611BE
	for <linux-scsi@archiver.kernel.org>; Sat,  8 May 2021 09:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhEHJmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 May 2021 05:42:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17160 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHJmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 May 2021 05:42:36 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fcj132mk6zncMX;
        Sat,  8 May 2021 17:38:15 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 8 May 2021 17:41:25 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: pmcraid: Remove several unneeded semicolons
Date:   Sat, 8 May 2021 17:41:18 +0800
Message-ID: <20210508094118.2783-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The semicolon immediately following '}' is unneeded.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/aha1542.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 1210e61afb1838a..7229748a57b95ff 100644
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
2.26.0.106.g9fadedd



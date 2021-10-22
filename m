Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B63C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 00:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE186135F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 00:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhJVApW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 20:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhJVApV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 20:45:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B4BC061764;
        Thu, 21 Oct 2021 17:43:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so1818165pjb.3;
        Thu, 21 Oct 2021 17:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNOVxOw71ipLbpQarDFMri/rDm9N6i/dmhNtzdX06Dw=;
        b=F+1mUxMmQHDDbRn4KS1V2l7xUPUrSVtSwT71KCZ/tqGx2zuahKGekU1zLUsj4819H2
         4ltmEvv1GI4krzoEvrxhGKbAaBbIkvZyKZYDbMtA5xiuQ0bT177yNLdO+hOsVs2X76Q9
         Z5Wxj9Lim4MvNjp9135Ud6qPpqT3b6kpTh412v0/7Bybj9n1bQYfrazZ00No0s///jLe
         ldS/E7e6by8AXiyU2xYVRUJKelkB08VhEtTV/yz5Zylwko5bwxkN0OGqdTZNk+M8qs1d
         jzf7lL0LFhWwMCQHnAC2cHe5g3qkeGb5e+o7+G1yIsCW4lE5AP3R4WSyWH43c97Ju5N7
         va1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNOVxOw71ipLbpQarDFMri/rDm9N6i/dmhNtzdX06Dw=;
        b=mJO+Sc3LofN2wbAym6mXp9KpgVduAehoQsPaTlxCMFm0O+BQZzjz+LBzoHFybRpN93
         +b1k5hk1rVKZIuu22GsY3kLIWTHSUV57tHO7WgY2QS4nzf/gjdRLaezasLYYRXBN4sW0
         asVsy7EUMhm6oDw5lUM+lJurWfB++7fSoffggdyZZAp3ZGnZlPCjqDvYwustYCgdszyz
         7tdv8GICQ3+Ainz/dSoksBc4h0DWUqA2mTXOZJ10ovfD0zNVwFhS6tTqchmJ3BKYoGOU
         h0k+ZD1SombVdUIHN0NprS7zhfatJWe3Obkw14vLpHoj805xQ5i4I3GNMDOdBR2YGyTt
         PT6A==
X-Gm-Message-State: AOAM531rO1OhmYUJDoV7IdkC6nBvQOmruCxhnpjxisSMwNsinwOpOmbF
        vzgQZhfewBds5gdHN2PekAhs8bmQ6Ow=
X-Google-Smtp-Source: ABdhPJzUtcFDw7YZrz7mJNpg1hCLCG+fkCMkbpDGV+aTWttOMbTPCPn+wNNrsP62y8Zpn/Grtfn0Rw==
X-Received: by 2002:a17:90a:5b0c:: with SMTP id o12mr10568417pji.11.1634863384224;
        Thu, 21 Oct 2021 17:43:04 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p13sm10488692pjb.44.2021.10.21.17.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 17:43:03 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi:aha1542: remove unneeded semicolon
Date:   Fri, 22 Oct 2021 00:42:45 +0000
Message-Id: <20211022004245.1061879-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

 Eliminate the following coccinelle check warning:
 drivers/scsi/aha1542.c:553:2-3
 drivers/scsi/aha1542.c:582:2-3
 drivers/scsi/aha1542.c:605:2-3
 drivers/scsi/aha1542.c:306:2-3
 drivers/scsi/aha1542.c:348:3-4
 drivers/scsi/aha1542.c:412:2-3
 drivers/scsi/aha1542.c:640:2-3
 drivers/scsi/aha1542.c:658:2-3
 drivers/scsi/aha1542.c:677:2-3
 drivers/scsi/aha1542.c:538:2-3

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/scsi/aha1542.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index f0e8ae9f5e40..a5a0a3e5c6ea 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -303,7 +303,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 		if (flag & SCRD)
 			printk("SCRD ");
 		printk("status %02x\n", inb(STATUS(sh->io_port)));
-	};
+	}
 #endif
 	number_serviced = 0;
 
@@ -345,7 +345,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 			if (!number_serviced)
 				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
 			return IRQ_HANDLED;
-		};
+		}
 
 		mbo = (scsi2int(mb[mbi].ccbptr) - (unsigned long)aha1542->ccb_handle) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
@@ -409,7 +409,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 						 */
 		scsi_done(tmp_cmd);
 		number_serviced++;
-	};
+	}
 }
 
 static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
@@ -535,7 +535,7 @@ static void setup_mailboxes(struct Scsi_Host *sh)
 		any2scsi(aha1542->mb[i].ccbptr,
 			 aha1542->ccb_handle + i * sizeof(struct ccb));
 		aha1542->mb[AHA1542_MAILBOXES + i].status = 0;
-	};
+	}
 	aha1542_intr_reset(sh->io_port);	/* reset interrupts, so they don't block */
 	any2scsi(mb_cmd + 2, aha1542->mb_handle);
 	if (aha1542_out(sh->io_port, mb_cmd, 5))
@@ -550,7 +550,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_RETCONF);
 	aha1542_in(sh->io_port, inquiry_result, 3, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -579,7 +579,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine DMA channel.\n");
 		return -1;
-	};
+	}
 	switch (inquiry_result[1]) {
 	case 0x40:
 		sh->irq = 15;
@@ -602,7 +602,7 @@ static int aha1542_getconfig(struct Scsi_Host *sh)
 	default:
 		shost_printk(KERN_ERR, sh, "Unable to determine IRQ level.\n");
 		return -1;
-	};
+	}
 	sh->this_id = inquiry_result[2] & 7;
 	return 0;
 }
@@ -637,7 +637,7 @@ static int aha1542_mbenable(struct Scsi_Host *sh)
 
 		if (aha1542_out(sh->io_port, mbenable_cmd, 3))
 			goto fail;
-	};
+	}
 	while (0) {
 fail:
 		shost_printk(KERN_ERR, sh, "Mailbox init failed\n");
@@ -655,7 +655,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	i = inb(STATUS(sh->io_port));
 	if (i & DF) {
 		i = inb(DATA(sh->io_port));
-	};
+	}
 	aha1542_outb(sh->io_port, CMD_INQUIRY);
 	aha1542_in(sh->io_port, inquiry_result, 4, 0);
 	if (!wait_mask(INTRFLAGS(sh->io_port), INTRMASK, HACC, 0, 0))
@@ -674,7 +674,7 @@ static int aha1542_query(struct Scsi_Host *sh)
 	if (inquiry_result[0] == 0x43) {
 		shost_printk(KERN_INFO, sh, "Emulation mode not supported for AHA-1740 hardware, use aha1740 driver instead.\n");
 		return 1;
-	};
+	}
 
 	/*
 	 * Always call this - boards that do not support extended bios translation
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DD5C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E047122B2C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhAJQ7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:59:38 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:39146 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAJQ7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 11:59:37 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru D363120AAB1E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH 2/3] aha1542: kill trailing whitespace
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <59829052-4932-4ea3-b504-857bbb19e6a0@omprussia.ru>
Date:   Sun, 10 Jan 2021 19:48:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some source lines (mostly the comments) in this driver end with spaces, as
reported by 'scripts/checkpatch.pl' -- let's trim these lines.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/scsi/aha1542.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: scsi/drivers/scsi/aha1542.c
===================================================================
--- scsi.orig/drivers/scsi/aha1542.c
+++ scsi/drivers/scsi/aha1542.c
@@ -894,9 +894,9 @@ static int aha1542_dev_reset(struct scsi
 	ccb[mbo].linkptr[0] = ccb[mbo].linkptr[1] = ccb[mbo].linkptr[2] = 0;
 	ccb[mbo].commlinkid = 0;
 
-	/* 
-	 * Now tell the 1542 to flush all pending commands for this 
-	 * target 
+	/*
+	 * Now tell the 1542 to flush all pending commands for this
+	 * target
 	 */
 	aha1542_outb(sh->io_port, CMD_START_SCSI);
 	spin_unlock_irqrestore(sh->host_lock, flags);
@@ -915,7 +915,7 @@ static int aha1542_reset(struct scsi_cmn
 	int i;
 
 	spin_lock_irqsave(sh->host_lock, flags);
-	/* 
+	/*
 	 * This does a scsi reset for all devices on the bus.
 	 * In principle, we could also reset the 1542 - should
 	 * we do this?  Try this first, and we can add that later
@@ -939,7 +939,7 @@ static int aha1542_reset(struct scsi_cmn
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
 	 * free any internal data structures, and basically clear things
-	 * out.  We do not try and restart any commands or anything - 
+	 * out.  We do not try and restart any commands or anything -
 	 * the strategy handler takes care of that crap.
 	 */
 	shost_printk(KERN_WARNING, cmd->device->host, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
@@ -1008,10 +1008,10 @@ static struct scsi_host_template driver_
 	.eh_bus_reset_handler	= aha1542_bus_reset,
 	.eh_host_reset_handler	= aha1542_host_reset,
 	.bios_param		= aha1542_biosparam,
-	.can_queue		= AHA1542_MAILBOXES, 
+	.can_queue		= AHA1542_MAILBOXES,
 	.this_id		= 7,
 	.sg_tablesize		= 16,
-	.unchecked_isa_dma	= 1, 
+	.unchecked_isa_dma	= 1,
 };
 
 static int aha1542_isa_match(struct device *pdev, unsigned int ndev)

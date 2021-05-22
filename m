Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62852C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 439CF61244
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhEVImM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5729 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhEVImH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:07 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnH041YyPzqVJH;
        Sat, 22 May 2021 16:37:08 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:40 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>
Subject: [PATCH 18/24] scsi: ncr53c8xx: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:22 +0800
Message-ID: <1621672648-39955-19-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
References: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/ncr53c8xx.c | 32 ++++++++++++++++----------------
 drivers/scsi/ncr53c8xx.h |  2 +-
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c76e9f0..0024bc5 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -2214,7 +2214,7 @@ static	struct script script0 __initdata = {
 		RADDR (scratcha),
 		RADDR (scratcha),
 	SCR_RETURN,
- 		0,
+		0,
 	SCR_JUMP ^ IFTRUE (IF (SCR_STATUS)),
 		PADDR (status),
 	SCR_JUMP ^ IFTRUE (IF (SCR_COMMAND)),
@@ -3760,7 +3760,7 @@ static void __init ncr_prepare_setting(struct ncb *np)
 
 	np->maxwide	= (np->features & FE_WIDE)? 1 : 0;
 
- 	/*
+	/*
 	 *  Guess the frequency of the chip's clock.
 	 */
 	if (np->features & FE_ULTRA)
@@ -3770,7 +3770,7 @@ static void __init ncr_prepare_setting(struct ncb *np)
 
 	/*
 	 *  Get the clock multiplier factor.
- 	 */
+	 */
 	if	(np->features & FE_QUAD)
 		np->multiplier	= 4;
 	else if	(np->features & FE_DBLR)
@@ -4541,7 +4541,7 @@ static void ncr_start_reset(struct ncb *np)
 {
 	if (!np->settle_time) {
 		ncr_reset_scsi_bus(np, 1, driver_setup.settle_delay);
- 	}
+	}
 }
  
 /*==========================================================
@@ -5204,11 +5204,11 @@ static void ncr_chip_reset(struct ncb *np, int delay)
 
 void ncr_init (struct ncb *np, int reset, char * msg, u_long code)
 {
- 	int	i;
+	int	i;
 
- 	/*
+	/*
 	**	Reset chip if asked, otherwise just clear fifos.
- 	*/
+	*/
 
 	if (reset) {
 		OUTB (nc_istat,  SRST);
@@ -7880,18 +7880,18 @@ static unsigned __init ncrgetfreq (struct ncb *np, int gen)
 			udelay(100);	/* count ms */
 	}
 	OUTB (nc_stime1, 0);	/* disable general purpose timer */
- 	/*
- 	 * set prescaler to divide by whatever 0 means
- 	 * 0 ought to choose divide by 2, but appears
- 	 * to set divide by 3.5 mode in my 53c810 ...
- 	 */
- 	OUTB (nc_scntl3, 0);
+	/*
+	 * set prescaler to divide by whatever 0 means
+	 * 0 ought to choose divide by 2, but appears
+	 * to set divide by 3.5 mode in my 53c810 ...
+	 */
+	OUTB (nc_scntl3, 0);
 
 	if (bootverbose >= 2)
 		printk ("%s: Delay (GEN=%d): %u msec\n", ncr_name(np), gen, ms);
-  	/*
- 	 * adjust for prescaler, and convert into KHz 
-  	 */
+	/*
+	 * adjust for prescaler, and convert into KHz
+	 */
 	return ms ? ((1 << gen) * 4340) / ms : 0;
 }
 
diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
index fa14b5c..b1567e8 100644
--- a/drivers/scsi/ncr53c8xx.h
+++ b/drivers/scsi/ncr53c8xx.h
@@ -757,7 +757,7 @@ struct ncr_reg {
 	#define   IRQM    0x08  /* mod: irq mode (1 = totem pole !) */
 	#define   STD     0x04  /* cmd: start dma mode              */
 	#define   IRQD    0x02  /* mod: irq disable                 */
- 	#define	  NOCOM   0x01	/* cmd: protect sfbr while reselect */
+	#define	  NOCOM   0x01	/* cmd: protect sfbr while reselect */
 				/* bits 0-1 rsvd for C1010          */
 
 /*3c*/  u32	nc_adder;
-- 
2.8.1


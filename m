Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C5BC2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A637613B6
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhEVImK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3627 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhEVImF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:05 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnH0148sxzQqVm;
        Sat, 22 May 2021 16:37:05 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 04/24] scsi: sym53c8xx: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:08 +0800
Message-ID: <1621672648-39955-5-git-send-email-tanghui20@huawei.com>
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

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/sym53c8xx_2/sym_defs.h |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 40 ++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_defs.h b/drivers/scsi/sym53c8xx_2/sym_defs.h
index 317289e..2d848615 100644
--- a/drivers/scsi/sym53c8xx_2/sym_defs.h
+++ b/drivers/scsi/sym53c8xx_2/sym_defs.h
@@ -234,7 +234,7 @@ struct sym_reg {
 	#define   IRQM    0x08  /* mod: irq mode (1 = totem pole !) */
 	#define   STD     0x04  /* cmd: start dma mode              */
 	#define   IRQD    0x02  /* mod: irq disable                 */
- 	#define	  NOCOM   0x01	/* cmd: protect sfbr while reselect */
+	#define	  NOCOM   0x01	/* cmd: protect sfbr while reselect */
 				/* bits 0-1 rsvd for C1010          */
 
 /*3c*/  u32	nc_adder;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 255a2d4..4c5e68c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -332,16 +332,16 @@ static unsigned getfreq (struct sym_hcb *np, int gen)
 		OUTW(np, nc_sien, 0);
 		OUTB(np, nc_istat1, 0);
 	}
- 	/*
- 	 * set prescaler to divide by whatever 0 means
- 	 * 0 ought to choose divide by 2, but appears
- 	 * to set divide by 3.5 mode in my 53c810 ...
- 	 */
- 	OUTB(np, nc_scntl3, 0);
-
-  	/*
- 	 * adjust for prescaler, and convert into KHz 
-  	 */
+	/*
+	 * set prescaler to divide by whatever 0 means
+	 * 0 ought to choose divide by 2, but appears
+	 * to set divide by 3.5 mode in my 53c810 ...
+	 */
+	OUTB(np, nc_scntl3, 0);
+
+	/*
+	 * adjust for prescaler, and convert into KHz
+	 */
 	f = ms ? ((1 << gen) * (4340*4)) / ms : 0;
 
 	/*
@@ -688,7 +688,7 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 
 	/*
 	 *  Get the clock multiplier factor.
- 	 */
+	 */
 	if	(np->features & FE_QUAD)
 		np->multiplier	= 4;
 	else if	(np->features & FE_DBLR)
@@ -774,11 +774,11 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 
 	/*
 	 *  Phase mismatch handled by SCRIPTS (895A/896/1010) ?
-  	 */
+	 */
 	if (np->features & FE_NOPM)
 		np->rv_ccntl0	|= (ENPMJ);
 
- 	/*
+	/*
 	 *  C1010-33 Errata: Part Number:609-039638 (rev. 1) is fixed.
 	 *  In dual channel mode, contention occurs if internal cycles
 	 *  are used. Disable internal cycles.
@@ -1692,12 +1692,12 @@ void sym_start_up(struct Scsi_Host *shost, int reason)
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
- 	int	i;
+	int	i;
 	u32	phys;
 
- 	/*
+	/*
 	 *  Reset chip if asked, otherwise just clear fifos.
- 	 */
+	 */
 	if (reason == 1)
 		sym_soft_reset(np);
 	else {
@@ -3080,7 +3080,7 @@ static void sym_sir_bad_scsi_status(struct sym_hcb *np, int num, struct sym_ccb
 		sym_dequeue_from_squeue(np, i, cp->target, cp->lun, -1);
 		OUTL_DSP(np, SCRIPTA_BA(np, start));
 
- 		/*
+		/*
 		 *  Save some info of the actual IO.
 		 *  Compute the data residual.
 		 */
@@ -3573,9 +3573,9 @@ static void sym_sir_task_recovery(struct sym_hcb *np, int num)
 		sym_clear_tasks(np, DID_ABORT, target, lun, task);
 		sym_flush_comp_queue(np, 0);
 
- 		/*
+		/*
 		 *  If we sent a BDR, make upper layer aware of that.
- 		 */
+		 */
 		if (np->abrt_msg[0] == M_RESET)
 			starget_printk(KERN_NOTICE, starget,
 							"has been reset\n");
@@ -4902,7 +4902,7 @@ static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np)
 	cp->phys.head.go.start   = cpu_to_scr(SCRIPTA_BA(np, idle));
 	cp->phys.head.go.restart = cpu_to_scr(SCRIPTB_BA(np, bad_i_t_l));
 
- 	/*
+	/*
 	 *  Initilialyze some other fields.
 	 */
 	cp->phys.smsg_ext.addr = cpu_to_scr(HCB_BA(np, msgin[2]));
-- 
2.8.1


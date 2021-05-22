Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0335C47083
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8909A6121E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEVImR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5730 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhEVImH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:07 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnH042hvKzqVJM;
        Sat, 22 May 2021 16:37:08 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:40 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>
Subject: [PATCH 19/24] scsi: mesh: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:23 +0800
Message-ID: <1621672648-39955-20-git-send-email-tanghui20@huawei.com>
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
 drivers/scsi/mesh.c | 54 ++++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 0a9f4e4..c6aa5a6 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -914,10 +914,10 @@ static void reselected(struct mesh_state *ms)
 		     MKWORD(0, mr->error, mr->exception, mr->fifo_count));
 	}
 	out_8(&mr->interrupt, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->sequence, SEQ_ENBRESEL);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->sync_params, ASYNC_PARAMS);
 
@@ -1010,7 +1010,7 @@ static void handle_reset(struct mesh_state *ms)
 	ms->msgphase = msg_none;
 	out_8(&mr->interrupt, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
 	out_8(&mr->sequence, SEQ_FLUSHFIFO);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->sync_params, ASYNC_PARAMS);
 	out_8(&mr->sequence, SEQ_ENBRESEL);
@@ -1723,7 +1723,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 	out_8(&mr->exception, 0xff);	/* clear all exception bits */
 	out_8(&mr->error, 0xff);	/* clear all error bits */
 	out_8(&mr->sequence, SEQ_RESETMESH);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->intr_mask, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
 	out_8(&mr->source_id, ms->host->this_id);
@@ -1732,7 +1732,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 
 	/* Reset the bus */
 	out_8(&mr->bus_status1, BS1_RST);	/* assert RST */
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(30);			/* leave it on for >= 25us */
 	out_8(&mr->bus_status1, 0);	/* negate RST */
 
@@ -1821,9 +1821,9 @@ static int mesh_shutdown(struct macio_dev *mdev)
 	volatile struct mesh_regs __iomem *mr;
 	unsigned long flags;
 
-       	printk(KERN_INFO "resetting MESH scsi bus(es)\n");
+	printk(KERN_INFO "resetting MESH scsi bus(es)\n");
 	spin_lock_irqsave(ms->host->host_lock, flags);
-       	mr = ms->mesh;
+	mr = ms->mesh;
 	out_8(&mr->intr_mask, 0);
 	out_8(&mr->interrupt, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
 	out_8(&mr->bus_status1, BS1_RST);
@@ -1870,17 +1870,17 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	if (macio_resource_count(mdev) != 2 || macio_irq_count(mdev) != 2) {
-       		printk(KERN_ERR "mesh: expected 2 addrs and 2 intrs"
+		printk(KERN_ERR "mesh: expected 2 addrs and 2 intrs"
 	       	       " (got %d,%d)\n", macio_resource_count(mdev),
 		       macio_irq_count(mdev));
 		return -ENODEV;
 	}
 
 	if (macio_request_resources(mdev, "mesh") != 0) {
-       		printk(KERN_ERR "mesh: unable to request memory resources");
+		printk(KERN_ERR "mesh: unable to request memory resources");
 		return -EBUSY;
 	}
-       	mesh_host = scsi_host_alloc(&mesh_template, sizeof(struct mesh_state));
+	mesh_host = scsi_host_alloc(&mesh_template, sizeof(struct mesh_state));
 	if (mesh_host == NULL) {
 		printk(KERN_ERR "mesh: couldn't register host");
 		goto out_release;
@@ -1888,12 +1888,12 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	
 	/* Old junk for root discovery, that will die ultimately */
 #if !defined(MODULE)
-       	note_scsi_host(mesh, mesh_host);
+	note_scsi_host(mesh, mesh_host);
 #endif
 
 	mesh_host->base = macio_resource_start(mdev, 0);
 	mesh_host->irq = macio_irq(mdev, 0);
-       	ms = (struct mesh_state *) mesh_host->hostdata;
+	ms = (struct mesh_state *) mesh_host->hostdata;
 	macio_set_drvdata(mdev, ms);
 	ms->host = mesh_host;
 	ms->mdev = mdev;
@@ -1911,11 +1911,11 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 		goto out_free;
 	}
 
-       	ms->meshintr = macio_irq(mdev, 0);
-       	ms->dmaintr = macio_irq(mdev, 1);
+	ms->meshintr = macio_irq(mdev, 0);
+	ms->dmaintr = macio_irq(mdev, 1);
 
-       	/* Space for dma command list: +1 for stop command,
-       	 * +1 to allow for aligning.
+	/* Space for dma command list: +1 for stop command,
+	 * +1 to allow for aligning.
 	 */
 	ms->dma_cmd_size = (mesh_host->sg_tablesize + 2) * sizeof(struct dbdma_cmd);
 
@@ -1931,25 +1931,25 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	}
 
 	ms->dma_cmds = (struct dbdma_cmd *) DBDMA_ALIGN(dma_cmd_space);
-       	ms->dma_cmd_space = dma_cmd_space;
+	ms->dma_cmd_space = dma_cmd_space;
 	ms->dma_cmd_bus = dma_cmd_bus + ((unsigned long)ms->dma_cmds)
 		- (unsigned long)dma_cmd_space;
 	ms->current_req = NULL;
-       	for (tgt = 0; tgt < 8; ++tgt) {
+	for (tgt = 0; tgt < 8; ++tgt) {
 	       	ms->tgts[tgt].sdtr_state = do_sdtr;
 	       	ms->tgts[tgt].sync_params = ASYNC_PARAMS;
 	       	ms->tgts[tgt].current_req = NULL;
-       	}
+	}
 
 	if ((cfp = of_get_property(mesh, "clock-frequency", NULL)))
-       		ms->clk_freq = *cfp;
+		ms->clk_freq = *cfp;
 	else {
-       		printk(KERN_INFO "mesh: assuming 50MHz clock frequency\n");
+		printk(KERN_INFO "mesh: assuming 50MHz clock frequency\n");
 	       	ms->clk_freq = 50000000;
-       	}
+	}
 
-       	/* The maximum sync rate is clock / 5; increase
-       	 * mesh_sync_period if necessary.
+	/* The maximum sync rate is clock / 5; increase
+	 * mesh_sync_period if necessary.
 	 */
 	minper = 1000000000 / (ms->clk_freq / 5); /* ns */
 	if (mesh_sync_period < minper)
@@ -1959,10 +1959,10 @@ static int mesh_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	set_mesh_power(ms, 1);
 
 	/* Set it up */
-       	mesh_init(ms);
+	mesh_init(ms);
 
 	/* Request interrupt */
-       	if (request_irq(ms->meshintr, do_mesh_interrupt, 0, "MESH", ms)) {
+	if (request_irq(ms->meshintr, do_mesh_interrupt, 0, "MESH", ms)) {
 	       	printk(KERN_ERR "MESH: can't get irq %d\n", ms->meshintr);
 		goto out_shutdown;
 	}
@@ -2012,7 +2012,7 @@ static int mesh_remove(struct macio_dev *mdev)
 
 	/* Unmap registers & dma controller */
 	iounmap(ms->mesh);
-       	iounmap(ms->dma);
+	iounmap(ms->dma);
 
 	/* Free DMA commands memory */
 	dma_free_coherent(&macio_get_pci_dev(mdev)->dev, ms->dma_cmd_size,
-- 
2.8.1


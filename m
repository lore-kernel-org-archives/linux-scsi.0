Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF997C47087
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB956121E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhEVImX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3909 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhEVImH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:07 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FnH0w1bmjzBv0l;
        Sat, 22 May 2021 16:37:52 +0800 (CST)
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
Subject: [PATCH 20/24] scsi: mac53c94: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:24 +0800
Message-ID: <1621672648-39955-21-git-send-email-tanghui20@huawei.com>
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
 drivers/scsi/mac53c94.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index ec9840d..f13c1cd 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -424,11 +424,11 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	}
 
 	if (macio_request_resources(mdev, "mac53c94") != 0) {
-       		printk(KERN_ERR "mac53c94: unable to request memory resources");
+		printk(KERN_ERR "mac53c94: unable to request memory resources");
 		return -EBUSY;
 	}
 
-       	host = scsi_host_alloc(&mac53c94_template, sizeof(struct fsc_state));
+	host = scsi_host_alloc(&mac53c94_template, sizeof(struct fsc_state));
 	if (host == NULL) {
 		printk(KERN_ERR "mac53c94: couldn't register host");
 		rc = -ENOMEM;
@@ -453,18 +453,18 @@ static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_id *mat
 	}
 
 	clkprop = of_get_property(node, "clock-frequency", &proplen);
-       	if (clkprop == NULL || proplen != sizeof(int)) {
-       		printk(KERN_ERR "%pOF: can't get clock frequency, "
-       		       "assuming 25MHz\n", node);
-       		state->clk_freq = 25000000;
-       	} else
-       		state->clk_freq = *(int *)clkprop;
-
-       	/* Space for dma command list: +1 for stop command,
-       	 * +1 to allow for aligning.
+	if (clkprop == NULL || proplen != sizeof(int)) {
+		printk(KERN_ERR "%pOF: can't get clock frequency, "
+		       "assuming 25MHz\n", node);
+		state->clk_freq = 25000000;
+	} else
+		state->clk_freq = *(int *)clkprop;
+
+	/* Space for dma command list: +1 for stop command,
+	 * +1 to allow for aligning.
 	 * XXX FIXME: Use DMA consistent routines
 	 */
-       	dma_cmd_space = kmalloc_array(host->sg_tablesize + 2,
+	dma_cmd_space = kmalloc_array(host->sg_tablesize + 2,
 					     sizeof(struct dbdma_cmd),
 					     GFP_KERNEL);
 	if (!dma_cmd_space) {
-- 
2.8.1


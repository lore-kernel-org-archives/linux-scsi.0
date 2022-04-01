Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233F5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 03:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244380AbiDADJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 23:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiDADJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 23:09:44 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C0A25CBA6;
        Thu, 31 Mar 2022 20:07:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V8lyzbN_1648782402;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V8lyzbN_1648782402)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 01 Apr 2022 11:07:52 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: pmcraid: Remove unneeded semicolon
Date:   Fri,  1 Apr 2022 11:06:40 +0800
Message-Id: <20220401030640.28246-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/scsi/pmcraid.c:4593:2-3: Unneeded semicolon.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index fd674ed1febe..3d5cd337a2a6 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4590,7 +4590,7 @@ static int pmcraid_init_instance(struct pci_dev *pdev, struct Scsi_Host *host,
 			mapped_pci_addr + chip_cfg->ioa_host_mask_clr;
 		pint_regs->global_interrupt_mask_reg =
 			mapped_pci_addr + chip_cfg->global_intr_mask;
-	};
+	}
 
 	pinstance->ioa_reset_attempts = 0;
 	init_waitqueue_head(&pinstance->reset_wait_q);
-- 
2.20.1.7.g153144c


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40CEC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35C2613A9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 03:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344459AbhDMDug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:50:36 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36737 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344458AbhDMDug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 23:50:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UVPm0hH_1618285814;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UVPm0hH_1618285814)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:50:15 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH v2] scsi: pmcraid: remove unneeded semicolon
Date:   Tue, 13 Apr 2021 11:50:14 +0800
Message-Id: <1618285814-110031-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/scsi/pmcraid.c:5090:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---

Change in v2:
--One patch per driver

 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 834556e..44e9709 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5087,7 +5087,7 @@ static int pmcraid_init_instance(struct pci_dev *pdev, struct Scsi_Host *host,
 			mapped_pci_addr + chip_cfg->ioa_host_mask_clr;
 		pint_regs->global_interrupt_mask_reg =
 			mapped_pci_addr + chip_cfg->global_intr_mask;
-	};
+	}
 
 	pinstance->ioa_reset_attempts = 0;
 	init_waitqueue_head(&pinstance->reset_wait_q);
-- 
1.8.3.1


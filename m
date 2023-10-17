Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B45CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 02:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjJQC7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 22:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjJQC7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 22:59:03 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850A38F;
        Mon, 16 Oct 2023 19:59:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VuLKkcu_1697511536;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VuLKkcu_1697511536)
          by smtp.aliyun-inc.com;
          Tue, 17 Oct 2023 10:58:56 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: pmcraid: Fix some kernel-doc comments
Date:   Tue, 17 Oct 2023 10:58:53 +0800
Message-Id: <20231017025853.67562-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix some kernel-doc comments to silence the warnings:
drivers/scsi/pmcraid.c:2697: warning: Excess function parameter 'scsi_cmd' description in 'pmcraid_reset_device'
drivers/scsi/pmcraid.c:2697: warning: Function parameter or member 'scsi_dev' not described in 'pmcraid_reset_device'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6843
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a831b34c08a4..af970cee53c9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2679,7 +2679,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 /**
  * pmcraid_reset_device - device reset handler functions
  *
- * @scsi_cmd: scsi command struct
+ * @scsi_dev: scsi device struct
  * @timeout: command timeout
  * @modifier: reset modifier indicating the reset sequence to be performed
  *
-- 
2.20.1.7.g153144c


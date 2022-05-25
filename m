Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9956EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 09:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiEYJfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiEYJfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 05:35:24 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0B08B094;
        Wed, 25 May 2022 02:35:22 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VEMuQ7p_1653471316;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VEMuQ7p_1653471316)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 May 2022 17:35:20 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     sathya.prakash@broadcom.com
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        sreekanth.reddy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: mpi3mr: Fix kernel-doc
Date:   Wed, 25 May 2022 17:35:14 +0800
Message-Id: <20220525093514.55467-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following W=1 kernel warnings:

drivers/scsi/mpi3mr/mpi3mr_app.c:1706: warning: expecting prototype for
adapter_state_show(). Prototype was for adp_state_show() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9ab1762468ad..113cf6f281be 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1693,7 +1693,7 @@ logging_level_store(struct device *dev,
 static DEVICE_ATTR_RW(logging_level);
 
 /**
- * adapter_state_show - SysFS callback for adapter state show
+ * adp_state_show() - SysFS callback for adapter state show
  * @dev: class device
  * @attr: Device attributes
  * @buf: Buffer to copy
-- 
2.20.1.7.g153144c


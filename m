Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A585C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Feb 2022 09:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiBMJAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 04:00:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiBMJAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 04:00:13 -0500
Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF745BD25;
        Sun, 13 Feb 2022 01:00:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=jnwang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4H7VRM_1644742790;
Received: from rsjc10526.et2sqa.tbsite.net(mailfrom:jnwang@linux.alibaba.com fp:SMTPD_---0V4H7VRM_1644742790)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 13 Feb 2022 17:00:03 +0800
From:   James Wang <jnwang@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, martin.petersen@oracle.com,
        jejb@linux.ibm.com, don.brace@microchip.com
Subject: [PATCH] [hpsa] Fix the wrong chars in comment section
Date:   Sun, 13 Feb 2022 16:59:50 +0800
Message-Id: <1644742790-87210-1-git-send-email-jnwang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These '+' should be redundant.

Signed-off-by: James Wang <jnwang@linux.alibaba.com>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a47bcce..34cd6c8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7641,8 +7641,8 @@ static void hpsa_free_cfgtables(struct ctlr_info *h)
 }
 
 /* Find and map CISS config table and transfer table
-+ * several items must be unmapped (freed) later
-+ * */
+ * several items must be unmapped (freed) later
+ * */
 static int hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
-- 
1.8.3.1


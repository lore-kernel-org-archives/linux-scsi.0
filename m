Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58432C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 01:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiBOBxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 20:53:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBOBxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 20:53:20 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DDC1405FD;
        Mon, 14 Feb 2022 17:53:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jnwang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4VVSdE_1644889961;
Received: from rsjc10526.et2sqa.tbsite.net(mailfrom:jnwang@linux.alibaba.com fp:SMTPD_---0V4VVSdE_1644889961)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 09:53:08 +0800
From:   James Wang <jnwang@linux.alibaba.com>
To:     don.brace@microsemi.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2] [hpsa] Fix the wrong chars in comment section
Date:   Tue, 15 Feb 2022 09:52:41 +0800
Message-Id: <1644889961-61470-1-git-send-email-jnwang@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <974edf4d-37fa-b25a-d0ac-33ac502381d8@acm.org>
References: <974edf4d-37fa-b25a-d0ac-33ac502381d8@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These '+' should be redundant.

Signed-off-by: James Wang <jnwang@linux.alibaba.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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
+ */
 static int hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
-- 
1.8.3.1


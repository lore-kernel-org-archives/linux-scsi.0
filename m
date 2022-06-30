Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7653C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 07:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiF3HmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 03:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiF3HmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 03:42:08 -0400
Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ECD3AA78;
        Thu, 30 Jun 2022 00:42:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VHr1SVp_1656574913;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VHr1SVp_1656574913)
          by smtp.aliyun-inc.com;
          Thu, 30 Jun 2022 15:42:03 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kashyap.desai@broadcom.com
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: megaraid_sas: Clean up some inconsistent indenting
Date:   Thu, 30 Jun 2022 15:41:52 +0800
Message-Id: <20220630074152.29171-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was found by coccicheck:

drivers/scsi/megaraid/megaraid_sas_base.c:3950 process_fw_state_change_wq() warn: inconsistent indenting.

Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c95360a3c186..fb28c8178828 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3947,9 +3947,9 @@ process_fw_state_change_wq(struct work_struct *work)
 	u32 wait;
 	unsigned long flags;
 
-    if (atomic_read(&instance->adprecovery) != MEGASAS_ADPRESET_SM_INFAULT) {
+	if (atomic_read(&instance->adprecovery) != MEGASAS_ADPRESET_SM_INFAULT) {
 		dev_notice(&instance->pdev->dev, "error, recovery st %x\n",
-				atomic_read(&instance->adprecovery));
+			   atomic_read(&instance->adprecovery));
 		return ;
 	}
 
-- 
2.20.1.7.g153144c


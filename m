Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCD2ECAAD8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 08:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiINIsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 04:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiINIsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 04:48:25 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2646696E9
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 01:48:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VPmX.Sr_1663145295;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VPmX.Sr_1663145295)
          by smtp.aliyun-inc.com;
          Wed, 14 Sep 2022 16:48:21 +0800
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] scsi: megaraid_sas: correct an error message
Date:   Wed, 14 Sep 2022 16:48:00 +0800
Message-Id: <1663145283-4872-3-git-send-email-kanie@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
References: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Correct the error message when alloc init request fail.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 44d5e93..4973c9c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7224,7 +7224,7 @@ int megasas_alloc_ctrl_dma_buffers(struct megasas_instance *instance)
 
 		if (!fusion->ioc_init_request) {
 			dev_err(&pdev->dev,
-				"Failed to allocate PD list buffer\n");
+				"Failed to allocate ioc init request\n");
 			return -ENOMEM;
 		}
 
-- 
1.8.3.1


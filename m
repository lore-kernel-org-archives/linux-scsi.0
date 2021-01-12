Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD758C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 08:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E43022D2C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 08:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbhALI0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 03:26:12 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:32335 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbhALI0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 03:26:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0ULVraBj_1610439895;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULVraBj_1610439895)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Jan 2021 16:25:19 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] scsi: lpfc: style: Simplify bool comparison
Date:   Tue, 12 Jan 2021 16:24:53 +0800
Message-Id: <1610439893-64872-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:
./drivers/scsi/lpfc/lpfc_bsg.c:5392:5-29: WARNING: Comparison to bool

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index eed6ea5..b974d39 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5376,9 +5376,9 @@ static int lpfc_bsg_check_cmd_access(struct lpfc_hba *phba,
 
 	ras_fwlog = &phba->ras_fwlog;
 
-	if (ras_fwlog->ras_hwsupport == false)
+	if (!ras_fwlog->ras_hwsupport)
 		return -EACCES;
-	else if (ras_fwlog->ras_enabled == false)
+	else if (!ras_fwlog->ras_enabled)
 		return -EPERM;
 	else
 		return 0;
-- 
1.8.3.1


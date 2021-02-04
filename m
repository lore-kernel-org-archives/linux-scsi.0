Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C2DC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 07:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8566764F48
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 07:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhBDHgY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:36:24 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49273 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234609AbhBDHgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 02:36:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UNpof-u_1612424127;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNpof-u_1612424127)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Feb 2021 15:35:27 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     christian.koenig@amd.com
Cc:     sumit.semwal@linaro.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, dick.kennedy@broadcom.com,
        james.smart@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi: lpfc: Remove unneeded return variable
Date:   Thu,  4 Feb 2021 15:35:25 +0800
Message-Id: <1612424125-91111-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes unneeded return variables, using only
'1' instead.
It fixes the following warning detected by coccinelle:

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 95caad7..31f97f6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3376,7 +3376,6 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 			  struct lpfc_iocbq *saveq)
 {
 	struct lpfc_iocbq *cmdiocbp;
-	int rc = 1;
 	unsigned long iflag;
 
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
@@ -3501,7 +3500,7 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = {
 		}
 	}
 
-	return rc;
+	return 1;
 }
 
 /**
-- 
1.8.3.1


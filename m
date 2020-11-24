Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719F0C83018
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7082076B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 09:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgKXJiv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 04:38:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47338 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731477AbgKXJic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 04:38:32 -0500
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1khUmK-0007Ty-Cq; Tue, 24 Nov 2020 09:38:28 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: pm8001: remove space in a debug message
Date:   Tue, 24 Nov 2020 09:38:28 +0000
Message-Id: <20201124093828.307709-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two words that need separating with a space in a 
pm8001_dbg message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 08d6cc9b50db..c8d4d87c5473 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1031,7 +1031,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	regVal = pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK);
 	pm8001_cw32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK, regVal3);
 	pm8001_dbg(pm8001_ha, INIT,
-		   "GSM 0x700048 - Write Data Parity Check Enableis set to = 0x%x\n",
+		   "GSM 0x700048 - Write Data Parity Check Enable is set to = 0x%x\n",
 		   pm8001_cr32(pm8001_ha, 2, GSM_WRITE_DATA_PARITY_CHECK));
 
 	/* step 13: bring the IOP and AAP1 out of reset */
-- 
2.29.2


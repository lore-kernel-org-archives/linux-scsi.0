Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA10C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94BB20C09
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgFQItV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:49:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59644 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFQItV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 04:49:21 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jlTkt-0000JZ-QT; Wed, 17 Jun 2020 08:49:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seungwon Jeon <essuuj@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: ufs-exynos: fix spelling mistake "pa_granularty" -> "pa_granularity"
Date:   Wed, 17 Jun 2020 09:49:11 +0100
Message-Id: <20200617084911.167359-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 440f2af83d9c..0a9e99084f2a 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -883,7 +883,7 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 		if (attr->pa_granularity < 1 || attr->pa_granularity > 6) {
 			/* Valid range for granularity: 1 ~ 6 */
 			dev_warn(hba->dev,
-				"%s: pa_granularty %d is invalid, assuming backwards compatibility\n",
+				"%s: pa_granularity %d is invalid, assuming backwards compatibility\n",
 				__func__,
 				attr->pa_granularity);
 			attr->pa_granularity = 6;
-- 
2.27.0.rc0


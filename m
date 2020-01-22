Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5590C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 09:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C71A52465B
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 09:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAVJNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:13:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35663 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVJNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 04:13:00 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuC4A-0001v2-FY; Wed, 22 Jan 2020 09:12:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: ufs: fix spelling mistake "initilized" -> "initialized"
Date:   Wed, 22 Jan 2020 09:12:50 +0000
Message-Id: <20200122091250.2777221-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_err message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index dde2eb02f76f..cfe380348bf0 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -546,7 +546,7 @@ static inline bool ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info,
 		u8 lun)
 {
 	if (!dev_info || !dev_info->max_lu_supported) {
-		pr_err("Max General LU supported by UFS isn't initilized\n");
+		pr_err("Max General LU supported by UFS isn't initialized\n");
 		return false;
 	}
 
-- 
2.24.0


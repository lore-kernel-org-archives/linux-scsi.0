Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A2BC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 00:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F99924673
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 00:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgAWA5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 19:57:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52825 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWA5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 19:57:10 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQny-0007ib-PY; Thu, 23 Jan 2020 00:57:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: pm80xx: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:57:06 +0000
Message-Id: <20200123005706.2834281-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pm8001_printk message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 98dcdbd146d5..d1d95f1a2c6a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2377,7 +2377,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				ts->buf_valid_size = sizeof(*resp);
 			} else
 				PM8001_IO_DBG(pm8001_ha,
-					pm8001_printk("response to large\n"));
+					pm8001_printk("response too large\n"));
 		}
 		if (pm8001_dev)
 			pm8001_dev->running_req--;
-- 
2.24.0


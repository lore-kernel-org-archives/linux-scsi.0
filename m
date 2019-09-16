Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AA8C49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 09:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A2DA20890
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 09:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbfIPJRQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 05:17:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34545 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbfIPJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2019 05:17:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1i9n86-0003ev-Iq; Mon, 16 Sep 2019 09:17:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     John Garry <john.garry@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: hisi_sas: fix spelling mistake "digial" -> "digital"
Date:   Mon, 16 Sep 2019 10:17:06 +0100
Message-Id: <20190916091706.32268-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d1513fdf1e00..e934d0b11745 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3539,7 +3539,7 @@ static const struct {
 	int		value;
 	char		*name;
 } hisi_sas_debugfs_loop_modes[] = {
-	{ HISI_SAS_BIST_LOOPBACK_MODE_DIGITAL, "digial" },
+	{ HISI_SAS_BIST_LOOPBACK_MODE_DIGITAL, "digital" },
 	{ HISI_SAS_BIST_LOOPBACK_MODE_SERDES, "serdes" },
 	{ HISI_SAS_BIST_LOOPBACK_MODE_REMOTE, "remote" },
 };
-- 
2.20.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300C0C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 13:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D68D6141D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 13:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhGBNST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 09:18:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33076 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbhGBNSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 09:18:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lzJ1D-0003O6-0J; Fri, 02 Jul 2021 13:15:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: remove redundant continue statement in a for-loop
Date:   Fri,  2 Jul 2021 14:15:42 +0100
Message-Id: <20210702131542.19880-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of the for-loop is redundant,
remove it.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 060c89237777..a0aeba69513d 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2936,7 +2936,6 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		liter += dburst - 1;
 		faddr += dburst - 1;
 		dwptr += dburst - 1;
-		continue;
 	}
 
 write_protect:
-- 
2.31.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C6AC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 12:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B246B610CF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 12:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245170AbhIYMzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 08:55:23 -0400
Received: from mx22.baidu.com ([220.181.50.185]:45452 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244971AbhIYMzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 08:55:20 -0400
Received: from BC-Mail-Ex29.internal.baidu.com (unknown [172.31.51.23])
        by Forcepoint Email with ESMTPS id C64399E873553E3BBD7B;
        Sat, 25 Sep 2021 20:53:44 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex29.internal.baidu.com (172.31.51.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Sat, 25 Sep 2021 20:53:44 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Sat, 25 Sep 2021 20:53:44 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Michael Reed <mdr@sgi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] scsi: 3w-xxxx: Fix a function name in comments
Date:   Sat, 25 Sep 2021 20:53:22 +0800
Message-ID: <20210925125324.1760-2-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210925125324.1760-1-caihuoqing@baidu.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex01.internal.baidu.com (10.127.64.11) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use dma_map_single() instead of pci_map_single(),
because only dma_map_single() is called here.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..afe35220ed29 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -156,7 +156,7 @@
                  same card number.
                  Fix bug where cards were being shut down more than once.
    1.02.00.029 - Add missing pci_free_consistent() in tw_allocate_memory().
-                 Replace pci_map_single() with pci_map_page() for highmem.
+                 Replace dma_map_single() with dma_map_page() for highmem.
                  Check for tw_setfeature() failure.
    1.02.00.030 - Make driver 64-bit clean.
    1.02.00.031 - Cleanup polling timeouts/routines in several places.
-- 
2.25.1


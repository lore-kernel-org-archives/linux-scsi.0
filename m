Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0216C47080
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0601613D6
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhEVImJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5726 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhEVImF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:05 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnH015zcrzqTtp;
        Sat, 22 May 2021 16:37:05 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Russell King <linux@armlinux.org.uk>
Subject: [PATCH 03/24] scsi: arm: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:07 +0800
Message-ID: <1621672648-39955-4-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
References: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/arm/fas216.c | 2 +-
 drivers/scsi/arm/fas216.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2e687ce..3f4a710 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2149,7 +2149,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 
 	SCpnt = info->SCpnt;
 	info->SCpnt = NULL;
-    	info->scsi.phase = PHASE_IDLE;
+	info->scsi.phase = PHASE_IDLE;
 
 	if (info->scsi.aborting) {
 		fas216_log(info, 0, "uncaught abort - returning DID_ABORT");
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 847413c..93ae0ad 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -279,7 +279,7 @@ typedef struct {
 	/* queue handling */
 	struct {
 	    	Queue_t		issue;			/* issue queue				*/
-    		Queue_t		disconnected;		/* disconnected command queue		*/
+		Queue_t		disconnected;		/* disconnected command queue		*/
 	} queues;
 
 	/* per-device info */
-- 
2.8.1


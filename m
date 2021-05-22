Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF53DC2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 10:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C62611CB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 10:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhEVK3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 06:29:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4585 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhEVK3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 06:29:07 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnKNJ2kGSzsT0d;
        Sat, 22 May 2021 18:24:48 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 18:27:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500008.china.huawei.com (7.185.36.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 18:27:36 +0800
From:   Hao Fang <fanghao11@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <prime.zeng@hisilicon.com>, <fanghao11@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Use the correct HiSilicon copyright
Date:   Sat, 22 May 2021 18:24:35 +0800
Message-ID: <1621679075-15404-1-git-send-email-fanghao11@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

s/Hisilicon/HiSilicon/.
It should use capital S, according to the official website
https://www.hisilicon.com/en.

Signed-off-by: Hao Fang <fanghao11@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index cf879cc..84ceddc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2015 Linaro Ltd.
- * Copyright (c) 2015 Hisilicon Limited.
+ * Copyright (c) 2015 HiSilicon Limited.
  */
 
 #ifndef _HISI_SAS_H_
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5a20407..acc3e13 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2015 Linaro Ltd.
- * Copyright (c) 2015 Hisilicon Limited.
+ * Copyright (c) 2015 HiSilicon Limited.
  */
 
 #include "hisi_sas.h"
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3e359ac..39588b0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2015 Linaro Ltd.
- * Copyright (c) 2015 Hisilicon Limited.
+ * Copyright (c) 2015 HiSilicon Limited.
  */
 
 #include "hisi_sas.h"
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 46f60fc..454bec9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright (c) 2016 Linaro Ltd.
- * Copyright (c) 2016 Hisilicon Limited.
+ * Copyright (c) 2016 HiSilicon Limited.
  */
 
 #include "hisi_sas.h"
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 499c770..7a1858f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Copyright (c) 2017 Hisilicon Limited.
+ * Copyright (c) 2017 HiSilicon Limited.
  */
 
 #include "hisi_sas.h"
-- 
2.8.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E34C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B0DC208B3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhALLQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:16:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11094 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhALLQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:16:39 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DFSdr01WjzMJJ9;
        Tue, 12 Jan 2021 19:14:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Tue, 12 Jan 2021 19:15:50 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        "Artur Paszkiewicz" <artur.paszkiewicz@intel.com>
Subject: [PATCH] MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL C600 SAS DRIVER
Date:   Tue, 12 Jan 2021 19:11:30 +0800
Message-ID: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mail address intel-linux-scu@intel.com bounces for Ahmed and I, so
just remove it.

Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6eff4f720c72..8571fad5489c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8882,7 +8882,6 @@ F:	drivers/mfd/intel_pmc_bxt.c
 F:	include/linux/mfd/intel_pmc_bxt.h
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
-M:	Intel SCU Linux support <intel-linux-scu@intel.com>
 M:	Artur Paszkiewicz <artur.paszkiewicz@intel.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.26.2


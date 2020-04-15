Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9402CC3815B
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DAEB20857
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635902AbgDOIYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:24:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894445AbgDOIYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 04:24:36 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 382BC1F0C3C86EEA717D;
        Wed, 15 Apr 2020 16:24:34 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 16:24:25 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <ben.hutchings@codethink.co.uk>,
        <rfontana@redhat.com>, <allison@lohutok.net>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <tglx@linutronix.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: mvsas: remove unused symbol 'mvs_th'
Date:   Wed, 15 Apr 2020 16:50:53 +0800
Message-ID: <20200415085053.7633-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This symbol has no users so remove it.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/mvsas/mv_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f82728b2c32f..5973eed94938 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -759,8 +759,6 @@ static DEVICE_ATTR(interrupt_coalescing,
 			 mvs_show_interrupt_coalescing,
 			 mvs_store_interrupt_coalescing);
 
-/* task handler */
-struct task_struct *mvs_th;
 static int __init mvs_init(void)
 {
 	int rc;
-- 
2.21.1


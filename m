Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C437C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAAB821D6C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIKJLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:11:49 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34448 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgIKJLt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 05:11:49 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 019B2B0476AA86467E49;
        Fri, 11 Sep 2020 17:11:47 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 17:11:36 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: fnic: remove unneeded semicolon
Date:   Fri, 11 Sep 2020 17:10:57 +0800
Message-ID: <20200911091057.2938685-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following coccinelle warning:

drivers/scsi/fnic/fnic_main.c:446:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8258348857e2..5f8a7ef8f6a8 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -443,7 +443,7 @@ static void fnic_notify_timer_start(struct fnic *fnic)
 	default:
 		/* Using intr for notification for INTx/MSI-X */
 		break;
-	};
+	}
 }
 
 static int fnic_dev_wait(struct vnic_dev *vdev,
-- 
2.25.4


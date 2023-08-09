Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B59BC04A6A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 14:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjHIOVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 10:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbjHIOVM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 10:21:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C7710F5
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 07:21:12 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RLXJD2Nx0zcbXf;
        Wed,  9 Aug 2023 22:19:56 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 9 Aug
 2023 22:21:08 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: Remove unused extern declarations
Date:   Wed, 9 Aug 2023 22:21:07 +0800
Message-ID: <20230809142107.42756-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These declarations is never implemented since the beginning of git history.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/scsi/scsi_priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index f42388ecb024..118855576ca8 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -103,7 +103,6 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
 void scsi_eh_done(struct scsi_cmnd *scmd);
 
 /* scsi_lib.c */
-extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
@@ -155,7 +154,6 @@ extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 extern void scsi_sysfs_device_initialize(struct scsi_device *);
-extern int scsi_sysfs_target_initialize(struct scsi_device *);
 extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
-- 
2.34.1


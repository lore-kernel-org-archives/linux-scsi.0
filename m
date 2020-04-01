Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9F3C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 13:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F952073B
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 13:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbgDANmd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 09:42:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12665 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732396AbgDANmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Apr 2020 09:42:33 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 30379F39C9E5CA655059;
        Wed,  1 Apr 2020 21:42:25 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 1 Apr 2020
 21:42:14 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, Jason Yan <yanaijie@huawei.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: remove show_use_blk_mq()
Date:   Wed, 1 Apr 2020 21:40:49 +0800
Message-ID: <20200401134049.9352-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code is useless now so remove it.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/scsi_sysfs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..6480e27982ab 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -386,15 +386,7 @@ show_host_busy(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR(host_busy, S_IRUGO, show_host_busy, NULL);
 
-static ssize_t
-show_use_blk_mq(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "1\n");
-}
-static DEVICE_ATTR(use_blk_mq, S_IRUGO, show_use_blk_mq, NULL);
-
 static struct attribute *scsi_sysfs_shost_attrs[] = {
-	&dev_attr_use_blk_mq.attr,
 	&dev_attr_unique_id.attr,
 	&dev_attr_host_busy.attr,
 	&dev_attr_cmd_per_lun.attr,
-- 
2.17.2


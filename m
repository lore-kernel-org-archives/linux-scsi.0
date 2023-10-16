Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC27CDB483
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 02:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjJPCJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 22:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjJPCJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 22:09:06 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E216C1;
        Sun, 15 Oct 2023 19:09:04 -0700 (PDT)
Received: from kwepemm000012.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4S80m20RQdzvQ2W;
        Mon, 16 Oct 2023 10:04:18 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm000012.china.huawei.com (7.193.23.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 16 Oct 2023 10:08:59 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH v2 0/2] cleanup patch
Date:   Mon, 16 Oct 2023 10:08:45 +0800
Message-ID: <20231016020847.1270258-1-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000012.china.huawei.com (7.193.23.142)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a cleanup patchset, no logic changed.

The first patch just cleanup scsi_dev_queue_ready();
The second patch add comment for target_destroy callback of
scsi_host_template to tell it is called in atomic context.

V2:
  - Tell which spinlock is held in comment of target_destroy

Wenchao Hao (2):
  scsi: core: cleanup scsi_dev_queue_ready()
  scsi: Add comment of target_destroy in scsi_host_template

 drivers/scsi/scsi_lib.c  | 35 ++++++++++++++++++-----------------
 include/scsi/scsi_host.h |  3 +++
 2 files changed, 21 insertions(+), 17 deletions(-)

-- 
2.32.0


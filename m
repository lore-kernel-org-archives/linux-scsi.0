Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0ADEE3F3F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 02:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbjIMCP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 22:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjIMCP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 22:15:56 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01A71713
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 19:15:52 -0700 (PDT)
Received: from kwepemd500002.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RlkXL0c3fz1N80p;
        Wed, 13 Sep 2023 10:13:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemd500002.china.huawei.com (7.221.188.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.23; Wed, 13 Sep 2023 10:15:48 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/3] Some fixes and optimizations for hisi_sas debugfs
Date:   Wed, 13 Sep 2023 10:15:24 +0800
Message-ID: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd500002.china.huawei.com (7.221.188.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The patchset includes:
- Fix NULL pointer issue when removing debugfs;
- Directly calling register snapshot instead of workqueue;
- Allocate debugfs memory during triggering debugfs dump;

Yihang Li (3):
  scsi: hisi_sas: Set debugfs_dir pointer to NULL after debugfs remove
  scsi: hisi_sas: Directly calling register snapshot instead of
    workqueue
  scsi: hisi_sas: Allocate DFX memory during dump trigger

 drivers/scsi/hisi_sas/hisi_sas.h       |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 116 +++++++++++++++------------------
 3 files changed, 59 insertions(+), 67 deletions(-)

-- 
2.8.1


Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1831EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 02:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjGKCok (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 22:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjGKCoi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 22:44:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6487B1AC
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2023 19:44:37 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R0QCv6hjKzVhkT;
        Tue, 11 Jul 2023 10:43:23 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 11 Jul 2023 10:44:34 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/3] Some misc changes
Date:   Tue, 11 Jul 2023 11:14:57 +0800
Message-ID: <1689045300-44318-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This series contain some fixes including:
- Fix completed I/O analysed as failed
- Block requests before a debugfs snapshot
- Delete unused lock in function hisi_sas_port_notify_formed()

Xingui Yang (1):
  scsi: hisi_sas: Fix normally completed I/O analysed as failed

Yihang Li (2):
  scsi: hisi_sas: Block requests before a debugfs snapshot
  scsi: hisi_sas: Delete unused lock in hisi_sas_port_notify_formed()

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 -----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 11 +++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++++-----
 3 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.8.1


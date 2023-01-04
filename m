Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CF9C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 03:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjADDct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Jan 2023 22:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjADDcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2023 22:32:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4674317428
        for <linux-scsi@vger.kernel.org>; Tue,  3 Jan 2023 19:32:45 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nmw9q3y0nzRqgZ;
        Wed,  4 Jan 2023 11:31:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 4 Jan 2023 11:32:42 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/2] hisi_sas: Some misc update
Date:   Wed, 4 Jan 2023 12:03:18 +0800
Message-ID: <1672805000-141102-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

There are two bugfixes related to hisi sas driver:
- Use abort task set command to reset SAS disks when discovered;
- Set a port invalid only if there is no devices attached when refreshing
port id;

Xingui Yang (1):
  scsi: hisi_sas: Use abort task set to reset SAS disks when discovered

Yihang Li (1):
  scsi: hisi_sas: Set a port invalid only if there is no devices
    attached when refreshing port id

 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.8.1


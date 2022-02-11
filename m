Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E422C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346072AbiBKGsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:48:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344026AbiBKGsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:48:22 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D51120
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:48:20 -0800 (PST)
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jw40P11sRz9scs;
        Fri, 11 Feb 2022 14:46:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:48:18 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/4] Some small cleanups for scsi/libsas
Date:   Fri, 11 Feb 2022 14:42:54 +0800
Message-ID: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

There are some cleanups related to scsi and libsas:
- Use void for sas_discover_event() return code;
- Remove duplicated setting for task->task_state_flags;
- Remove unused parameter for function sas_ata_eh();
- Remove unused member cmd_pool for structure scsi_host_template;

Xiang Chen (4):
  scsi: libsas: Use void for sas_discover_event() return code
  scsi: libsas: Remove duplicated setting for task->task_state_flags
  scsi: libsas: Remove unused parameter for function sas_ata_eh()
  scsi: Remove unused member cmd_pool for structure scsi_host_template

 drivers/scsi/libsas/sas_ata.c       | 4 +---
 drivers/scsi/libsas/sas_discover.c  | 6 ++----
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 include/scsi/libsas.h               | 2 +-
 include/scsi/sas_ata.h              | 6 ++----
 include/scsi/scsi_host.h            | 3 ---
 6 files changed, 7 insertions(+), 16 deletions(-)

-- 
2.33.0


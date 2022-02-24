Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C58C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 11:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiBXLL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 06:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiBXLLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 06:11:20 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3119128F446;
        Thu, 24 Feb 2022 03:10:42 -0800 (PST)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K497K661Qz685ZG;
        Thu, 24 Feb 2022 19:05:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 12:10:39 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 11:10:37 +0000
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <chenxiang66@hisilicon.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 0/2] scsi: libsas: Some minor improvements
Date:   Thu, 24 Feb 2022 19:04:57 +0800
Message-ID: <1645700699-82369-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This is just a couple of small improvements which we had sitting on our
dev branch. Please consider for 5.18.

Thanks!

John Garry (2):
  scsi: libsas: Make sas_notify_{phy,port}_event() return void
  scsi: libsas: Use bool for queue_work() return code

 drivers/scsi/libsas/sas_event.c    | 43 ++++++++++++------------------
 drivers/scsi/libsas/sas_internal.h |  4 +--
 include/scsi/libsas.h              |  8 +++---
 3 files changed, 22 insertions(+), 33 deletions(-)

-- 
2.26.2


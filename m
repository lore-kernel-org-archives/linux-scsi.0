Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC9EC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0426061A2C
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 12:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYM3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 08:29:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14590 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhCYM3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 08:29:33 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5krg4vnMz19H4N;
        Thu, 25 Mar 2021 20:27:31 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 20:29:22 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <luojiaxing@huawei.com>, <chenxiang66@hisilicon.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH v1 0/2] scsi: libsas: few clean up patches
Date:   Thu, 25 Mar 2021 20:29:54 +0800
Message-ID: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two types of errors are detected by the checkpatch.
1. Alignment between switches and cases
2. Improper use of some spaces

Here are the clean up patches.

Luo Jiaxing (2):
  scsi: libsas: make switch and case at the same indent in
    sas_to_ata_err()
  scsi: libsas: clean up for white spaces

 drivers/scsi/libsas/sas_ata.c      | 74 ++++++++++++++++++--------------------
 drivers/scsi/libsas/sas_discover.c |  2 +-
 drivers/scsi/libsas/sas_expander.c | 15 ++++----
 3 files changed, 43 insertions(+), 48 deletions(-)

-- 
2.7.4


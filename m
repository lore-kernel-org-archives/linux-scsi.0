Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93A0C63798
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 17:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 799172078E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 17:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389894AbgKWRpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 12:45:30 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8571 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730907AbgKWRpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 12:45:30 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfvgK1NKBzLt3w;
        Tue, 24 Nov 2020 01:45:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 01:45:17 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/3] hisi_sas: A small bunch of misc patches
Date:   Tue, 24 Nov 2020 01:41:33 +0800
Message-ID: <1606153296-60088-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains a small bunch of patches for the driver, including:
- Fix-up on error paths for v3 hw driver
- Relocate as much debugfs code as possible to v3 hw driver since
  no other hw drivers support it
- A small tidy-up patch

John Garry (1):
  scsi: hisi_sas: Reduce some indirection in v3 hw driver

Luo Jiaxing (1):
  scsi: hisi_sas: Move debugfs code to v3 hw driver

Xiang Chen (1):
  scsi: hisi_sas: Fix up probe error handling for v3 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |   28 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 1346 +-----------------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1254 +++++++++++++++++++++-
 3 files changed, 1224 insertions(+), 1404 deletions(-)

-- 
2.26.2


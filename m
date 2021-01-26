Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BA7C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9CF20691
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 12:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392027AbhAZMN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 07:13:57 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11880 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404908AbhAZLJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 06:09:18 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ3pw2pd9z7bF4;
        Tue, 26 Jan 2021 19:07:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 19:08:24 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/5] hisi_sas: More misc patches
Date:   Tue, 26 Jan 2021 19:04:23 +0800
Message-ID: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a collection of misc patches picked up during the latest dev
cycle, targeted at 5.12 .

Features include:
- Some tidy-up from after recent change to expose HW queues on v2 HW
- Add trace FIFO DFX debugfs support
- Flush wq for driver removal
- Add ability to enable debugfs support as a kernel config option

Thanks!

John Garry (2):
  scsi: hisi_sas: Remove deferred probe check in hisi_sas_v2_probe()
  scsi: hisi_sas: Don't check .nr_hw_queues in hisi_sas_task_prep()

Luo Jiaxing (3):
  scsi: hisi_sas: Enable debugfs support by default
  scsi: hisi_sas: Flush workqueue in hisi_sas_v3_remove()
  scsi: hisi_sas: Add trace FIFO debugfs support

 drivers/scsi/hisi_sas/Kconfig          |   6 +
 drivers/scsi/hisi_sas/hisi_sas.h       |  15 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  19 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  12 --
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 252 +++++++++++++++++++++++++
 5 files changed, 286 insertions(+), 18 deletions(-)

-- 
2.26.2


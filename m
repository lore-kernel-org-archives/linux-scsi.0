Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA793C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 771986128A
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343524AbhDFLwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:52:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15135 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhDFLww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 07:52:52 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FF5Rp1tSczpVLN;
        Tue,  6 Apr 2021 19:49:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 19:52:36 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.orgc>,
        <linuxarm@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/6] hisi_sas: Some misc patches
Date:   Tue, 6 Apr 2021 19:48:25 +0800
Message-ID: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains some more minor patches for the driver, including:
- Improve debugfs code to snapshot registers prior to reset
- Fix probe error path
- Remove unused code
- Print SAS address in some error logs to assist debugging

Thanks!!

Jianqin Xie (1):
  scsi: hisi_sas: Directly snapshot registers when executing a reset

Luo Jiaxing (4):
  scsi: hisi_sas: Delete some unused callbacks
  scsi: hisi_sas: Print SAS address for v3 hw erroneous completion print
  scsi: hisi_sas: Warn in v3 hw channel interrupt handler when status
    reg cleared
  scsi: hisi_sas: Print SATA device SAS address for soft reset failure

Xiang Chen (1):
  scsi: hisi_sas: Call sas_unregister_ha() to roll back if .hw_init()
    fails

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 38 +++++++++++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 44 ++++++++++++++++----------
 3 files changed, 56 insertions(+), 29 deletions(-)

-- 
2.26.2


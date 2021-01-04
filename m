Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1ACFC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3CF22482
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhADMie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:38:34 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10106 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbhADMid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 07:38:33 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8Zr60dKCzMFBH;
        Mon,  4 Jan 2021 20:36:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 20:37:37 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <maz@kernel.org>,
        <kashyap.desai@broadcom.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/2] hisi_sas: Expose hw queues for v2 hw and remove unused code
Date:   Mon, 4 Jan 2021 20:33:40 +0800
Message-ID: <1609763622-34119-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patch "scsi: hisi_sas: Expose HW queues for v2 hw" was not merged for
v5.11, so resending for v5.12.

Unused module param auto_affine_msi_experimental for v3 hw is also
removed in the other patch.

John Garry (2):
  scsi: hisi_sas: Remove auto_affine_msi_experimental module_param
  scsi: hisi_sas: Expose HW queues for v2 hw

 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 +++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 66 +++++++++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 --
 4 files changed, 68 insertions(+), 18 deletions(-)

-- 
2.26.2


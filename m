Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF14C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71CEC2076D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgGMIIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:08:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729003AbgGMIIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 04:08:38 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A3335CD7ED0F73AB76F0;
        Mon, 13 Jul 2020 16:08:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Jul 2020 16:08:27 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/2] hisi_sas: A couple of misc patches
Date:   Mon, 13 Jul 2020 16:04:29 +0800
Message-ID: <1594627471-235395-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Includes a patch to speed up error handling and a kerneldoc clean-up.

John Garry (1):
  scsi: hisi_sas: Remove one kerneldoc comment

Luo Jiaxing (1):
  scsi: hisi_sas: Directly trigger SCSI error handling for completion
    errors

 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +++-
 3 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.26.2


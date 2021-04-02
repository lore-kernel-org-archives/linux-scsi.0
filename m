Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0233DC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 09:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F5A61105
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 09:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbhDBJId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:08:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15590 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbhDBJI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 05:08:26 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FBZ0l10h0z1BG8D;
        Fri,  2 Apr 2021 17:06:15 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Fri, 2 Apr 2021
 17:08:12 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <luojiaxing@huawei.com>
Subject: [PATCH v1 0/2] scsi: pm8001: tiny clean up patches
Date:   Fri, 2 Apr 2021 17:08:40 +0800
Message-ID: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Several error is reported by checkpatch.pl, here are two patches to clean
them up.

Luo Jiaxing (2):
  scsi: pm8001: clean up for white space
  scsi: pm8001: clean up for open brace

 drivers/scsi/pm8001/pm8001_ctl.c |  8 +++-----
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
 drivers/scsi/pm8001/pm8001_sas.c | 20 ++++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++-------
 5 files changed, 28 insertions(+), 30 deletions(-)

-- 
2.7.4


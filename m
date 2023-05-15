Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19260C77B7D
	for <linux-scsi@archiver.kernel.org>; Mon, 15 May 2023 02:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjEOCKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 May 2023 22:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjEOCKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 May 2023 22:10:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2689910E7
        for <linux-scsi@vger.kernel.org>; Sun, 14 May 2023 19:10:51 -0700 (PDT)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKN5g0plMzqSHW;
        Mon, 15 May 2023 10:06:31 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:10:48 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 0/3] scsi: hisi_sas: Some misc changes
Date:   Mon, 15 May 2023 10:41:18 +0800
Message-ID: <1684118481-95908-1-git-send-email-chenxiang66@hisilicon.com>
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

This series contain some fixes including:
- Configure initial value of some registers according to HBA model
- Change DMA setup lock timeout from 100ms to 2.5s
- Fix warnings detected by sparse

Xingui Yang (2):
  scsi: hisi_sas: Change DMA setup lock timeout to 2.5s
  scsi: hisi_sas: Fix warnings detected by sparse

Yihang Li (1):
  scsi: hisi_sas: Configure initial value of some registers according to
    HBA model

 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

-- 
2.8.1


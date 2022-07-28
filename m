Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9B5C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 02:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiG1C2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jul 2022 22:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiG1C2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2022 22:28:46 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD2152DF0;
        Wed, 27 Jul 2022 19:28:38 -0700 (PDT)
X-UUID: 82e6bf47a6424cc694de4794d6b47828-20220728
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:9296a40b-1f1f-4bab-bfa6-cfead44dca6e,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:0f94e32,CLOUDID:febf1836-fd9a-435f-8e8b-e247f150d0a2,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 82e6bf47a6424cc694de4794d6b47828-20220728
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 200118487; Thu, 28 Jul 2022 10:28:36 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 28 Jul 2022 10:28:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 28 Jul 2022 10:28:34 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <bvanassche@acm.org>
CC:     <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <powen.kao@mediatek.com>,
        <mason.zhang@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <eddie.huang@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <stanley.chu@mediatek.com>
Subject: [PATCH v3 0/5] scsi: ufs-mediatek: Provide features and fixes in MediaTek platforms
Date:   Thu, 28 Jul 2022 10:28:28 +0800
Message-ID: <20220728022833.16243-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series provides some features and fixes in MediaTek UFS platforms.
Please consider this patch series for kernel v5.20.

Changes since v2:
 - Remove Change-ID tag in patch "scsi: ufs: ufs-mediatek: Remove redundant header files" (Bart)
 - Move const string table to ufs-mediatek.c from ufs-mediatek.h (Bart)

Changes since v1:
 - Remove unnecessary changes in patch "scsi: ufs: ufs-mediatek: Fix performance scaling"

Peter Wang (2):
  scsi: ufs: ufs-mediatek: Dump more registers
  scsi: ufs: ufs-mediatek: Fix performance scaling

Po-Wen Kao (1):
  scsi: ufs: ufs-medaitek: Support clk-scaling to optimize power
    consumption

Stanley Chu (2):
  scsi: ufs: ufs-mediatek: Remove redundant header files
  scsi: ufs: ufs-mediatek: Provide detailed description for UIC errors

 drivers/ufs/host/ufs-mediatek-trace.h |  25 +++-
 drivers/ufs/host/ufs-mediatek.c       | 205 +++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h       |   7 +
 3 files changed, 229 insertions(+), 8 deletions(-)

-- 
2.18.0


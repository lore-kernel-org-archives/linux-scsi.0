Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434BDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353288AbiFVHhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353171AbiFVHhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 03:37:32 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CA377C3;
        Wed, 22 Jun 2022 00:37:26 -0700 (PDT)
X-UUID: cb5c888ad1124e159d54a67e8346e66e-20220622
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:70b28f9d-5e0b-46d9-9e62-f6ab7f393978,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:90
X-CID-INFO: VERSION:1.1.6,REQID:70b28f9d-5e0b-46d9-9e62-f6ab7f393978,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:90
X-CID-META: VersionHash:b14ad71,CLOUDID:c7272738-5e4b-44d7-80b2-bb618cb09d29,C
        OID:3cefd29a4102,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: cb5c888ad1124e159d54a67e8346e66e-20220622
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2107278437; Wed, 22 Jun 2022 15:37:21 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 22 Jun 2022 15:37:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 22 Jun 2022 15:37:20 +0800
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
Subject: [PATCH v1 0/7] Provide features and fixes in MediaTek UFS platform
Date:   Wed, 22 Jun 2022 15:37:12 +0800
Message-ID: <20220622073719.21599-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This series provides some fixes and features in MediaTek UFS platform.
Please consider this patch series for kernel v5.20.

Peter Wang (4):
  scsi: ufs-mediatek: Always add delays for VCC operations
  scsi: ufs-mediatek: Prevent host hang by setting CLK_CG early
  scsi: ufs-mediatek: Add stage information for ref-clk control
  scsi: ufs-mediatek: Support performance boosting

Po-Wen Kao (2):
  scsi: ufs-mediatek: Disable reset confirm feature by UniPro
  scsi: ufs-mediatek: Support host power control

Stanley Chu (1):
  scsi: ufs-mediatek: Fix build warnings

 drivers/ufs/host/ufs-mediatek.c | 76 ++++++++++++++++++++++++---------
 drivers/ufs/host/ufs-mediatek.h | 20 ++++++++-
 2 files changed, 75 insertions(+), 21 deletions(-)

-- 
2.18.0


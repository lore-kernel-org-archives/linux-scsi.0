Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C257C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08BF9235FF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbhAVIjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:39:47 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:52444 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbhAVIi1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 03:38:27 -0500
X-UUID: 6be9fd9f647a492380ef63eac5be8551-20210122
X-UUID: 6be9fd9f647a492380ef63eac5be8551-20210122
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1481106957; Fri, 22 Jan 2021 16:36:41 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 22 Jan 2021 16:36:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 Jan 2021 16:36:38 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>
CC:     <linux-mediatek@lists.infradead.org>, <yingjoe.chen@mediatek.com>,
        <matthias.bgg@gmail.com>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <alice.chao@mediatek.com>,
        <chaotian.jing@mediatek.com>, <cc.chou@mediatek.com>,
        <jiajie.hao@mediatek.com>, <hanks.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 1/2] arm64: configs: Support Universal Flash Storage on MediaTek platforms
Date:   Fri, 22 Jan 2021 16:36:26 +0800
Message-ID: <20210122083627.2893-2-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210122083627.2893-1-stanley.chu@mediatek.com>
References: <20210122083627.2893-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: F1840B8654F83275B0B86B7812F4FA79CD6A7E398873C42452E32310C25006012000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support UFS on MediaTek platforms by enabling CONFIG_SCSI_UFS_MEDIATEK.

Reviewed-by: Hanks Chen <hanks.chen@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 838301650a79..12ff990b2691 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -283,6 +283,7 @@ CONFIG_SCSI_MPT3SAS=m
 CONFIG_SCSI_UFSHCD=y
 CONFIG_SCSI_UFSHCD_PLATFORM=y
 CONFIG_SCSI_UFS_QCOM=m
+CONFIG_SCSI_UFS_MEDIATEK=m
 CONFIG_SCSI_UFS_HISI=y
 CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
-- 
2.18.0


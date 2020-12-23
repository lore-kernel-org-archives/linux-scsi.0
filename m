Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31002C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A64E22525
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 04:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgLWEOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 23:14:34 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41695 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgLWEOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 23:14:33 -0500
X-UUID: 096b60bf2fbe4ce98979962b3359f3a0-20201223
X-UUID: 096b60bf2fbe4ce98979962b3359f3a0-20201223
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1456249984; Wed, 23 Dec 2020 12:13:47 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Dec 2020 12:13:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Dec 2020 12:13:45 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, <hanks.chen@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] arm64: Support Universal Flash Storage on MediaTek MT6779 platform
Date:   Wed, 23 Dec 2020 12:13:43 +0800
Message-ID: <20201223041345.24864-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series adds UFS (Universal Flash Storage) support on MediaTek MT6779 SoC platform.

Stanley Chu (2):
  arm64: configs: Support Universal Flash Storage on MediaTek platforms
  arm64: dts: mt6779: Support ufshci and ufsphy

 arch/arm64/boot/dts/mediatek/mt6779.dtsi | 36 +++++++++++++++++++++++-
 arch/arm64/configs/defconfig             |  1 +
 2 files changed, 36 insertions(+), 1 deletion(-)

-- 
2.18.0


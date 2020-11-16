Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B452FC55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4752073C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 06:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbgKPGvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:51:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:59517 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727166AbgKPGvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 01:51:01 -0500
X-UUID: ffa5188b57fd4f078e325a969e0568ed-20201116
X-UUID: ffa5188b57fd4f078e325a969e0568ed-20201116
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 603744827; Mon, 16 Nov 2020 14:50:56 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 16 Nov 2020 14:50:55 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 16 Nov 2020 14:50:55 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <kwmad.kim@samsung.com>,
        <liwei213@huawei.com>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/9] scsi: ufs: Refactoring and cleanups
Date:   Mon, 16 Nov 2020 14:50:45 +0800
Message-ID: <20201116065054.7658-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series simply do some refactoring and cleanups in UFS drivers.

Stanley Chu (9):
  scsi: ufs-mediatek: Refactor performance scaling functions
  scsi: ufs: Introduce device parameter initialization function
  scsi: ufs-mediatek: Use device parameter initialization function
  scsi: ufs-qcom: Use device parameter initialization function
  scsi: ufs-exynos: Use device parameter initialization function
  scsi: ufs-hisi: Use device parameter initialization function
  scsi: ufs: Refactor ADAPT configuration function
  scsi: ufs-mediatek: Use common ADAPT configuration function
  scsi: ufs-qcom: Use common ADAPT configuration function

 drivers/scsi/ufs/ufs-exynos.c    | 15 +---------
 drivers/scsi/ufs/ufs-exynos.h    | 13 --------
 drivers/scsi/ufs/ufs-hisi.c      | 13 +-------
 drivers/scsi/ufs/ufs-hisi.h      | 13 --------
 drivers/scsi/ufs/ufs-mediatek.c  | 51 ++++++++++++++------------------
 drivers/scsi/ufs/ufs-mediatek.h  | 16 ----------
 drivers/scsi/ufs/ufs-qcom.c      | 27 +++--------------
 drivers/scsi/ufs/ufs-qcom.h      | 11 -------
 drivers/scsi/ufs/ufshcd-pltfrm.c | 17 +++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.h |  1 +
 drivers/scsi/ufs/ufshcd.c        | 16 ++++++++++
 drivers/scsi/ufs/ufshcd.h        |  3 ++
 12 files changed, 65 insertions(+), 131 deletions(-)

-- 
2.18.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9266CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7908A61037
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 15:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240994AbhJOPlU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:41:20 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:42554 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S236778AbhJOPlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 11:41:19 -0400
X-UUID: a91edccbeb594c1ba5f83041c14216d1-20211015
X-UUID: a91edccbeb594c1ba5f83041c14216d1-20211015
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1174487801; Fri, 15 Oct 2021 23:39:09 +0800
Received: from mtkexhb02.mediatek.inc (172.21.101.103) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 15 Oct 2021 23:39:08 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 15 Oct
 2021 23:39:07 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 15 Oct 2021 23:39:07 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <alice.chao@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <peter.wang@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <chaotian.jing@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <gray.jia@mediatek.com>, <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs-mediatek: Fix two defects in MediaTek UFS driver
Date:   Fri, 15 Oct 2021 23:39:04 +0800
Message-ID: <20211015153906.21929-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series fixes two defects in MediaTek UFS drivers.

Stanley Chu (2):
  scsi: ufs-mediatek: Introduce default delay for reference clock
  scsi: ufs-mediatek: Fix build error of using sched_clock()

 drivers/scsi/ufs/ufs-mediatek.c | 14 +++++++++-----
 drivers/scsi/ufs/ufs-mediatek.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.18.0


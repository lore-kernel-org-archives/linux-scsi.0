Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25588C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 00:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0472561247
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Oct 2021 00:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbhJPBAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 21:00:21 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:47040 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S239438AbhJPBAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 21:00:15 -0400
X-UUID: e61a754a96ee4be49f95e5c1ae32c868-20211016
X-UUID: e61a754a96ee4be49f95e5c1ae32c868-20211016
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1721665155; Sat, 16 Oct 2021 08:58:04 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 16 Oct 2021 08:58:03 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 16 Oct 2021 08:58:03 +0800
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
Subject: [PATCH v2 0/3] scsi: ufs-mediatek: Fix some defects in MediaTek UFS driver
Date:   Sat, 16 Oct 2021 08:57:59 +0800
Message-ID: <20211016005802.7729-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This series fixes some defects in MediaTek UFS drivers.

Change since v1:
- Add patch [3/3] scsi: ufs-mediatek: Fix wrong place of ref-clk delay

Peter Wang (1):
  scsi: ufs-mediatek: Fix wrong place of ref-clk delay

Stanley Chu (2):
  scsi: ufs-mediatek: Introduce default delay for reference clock
  scsi: ufs-mediatek: Fix build error of using sched_clock()

 drivers/scsi/ufs/ufs-mediatek.c | 22 +++++++++++++---------
 drivers/scsi/ufs/ufs-mediatek.h |  1 +
 2 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.18.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEADC47089
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B62160238
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 03:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhE1DiT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 23:38:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:59797 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233801AbhE1DiS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 23:38:18 -0400
X-UUID: 18ac5022bf234f08919f34844cc6b38c-20210528
X-UUID: 18ac5022bf234f08919f34844cc6b38c-20210528
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <alice.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1533591400; Fri, 28 May 2021 11:36:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 May 2021 11:36:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 May 2021 11:36:35 +0800
From:   Alice <alice.chao@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: [PATCH v2 0/2] scsi: ufs-mediatek: Disable HCI before HW reset
Date:   Fri, 28 May 2021 11:36:20 +0800
Message-ID: <20210528033624.12170-1-alice.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
This series changes the hw reset timing to avoid potential issues in MediaTek platform.

Change since v1:
- Fix the commit message of patch 2

Alice.Chao (2):
  scsi: ufs: Export ufshcd_hba_stop
  scsi: ufs-mediatek: Disable HCI before HW reset

 drivers/scsi/ufs/ufs-mediatek.c | 3 +++
 drivers/scsi/ufs/ufshcd.c       | 3 ++-
 drivers/scsi/ufs/ufshcd.h       | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.18.0


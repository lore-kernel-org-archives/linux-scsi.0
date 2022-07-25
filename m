Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8390C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 13:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbiGYNQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiGYNQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 09:16:17 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17A2B7F9
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 06:16:07 -0700 (PDT)
X-UUID: 9dcbe4a7344d49ca90c2f51604e5dc9d-20220725
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:c40ec52a-c705-4761-9329-eb5dc586cac9,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:100
X-CID-INFO: VERSION:1.1.8,REQID:c40ec52a-c705-4761-9329-eb5dc586cac9,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:95,FILE:0,RULE:Spam_GS981B3D,ACT
        ION:quarantine,TS:100
X-CID-META: VersionHash:0f94e32,CLOUDID:239270b3-06d2-48ef-b2dd-540836705165,C
        OID:710f80276eea,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 9dcbe4a7344d49ca90c2f51604e5dc9d-20220725
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 58283811; Mon, 25 Jul 2022 21:16:03 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 25 Jul 2022 21:16:02 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Mon, 25 Jul 2022 21:16:02 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: [PATCH v1] ufs: core: change comment message to popular format
Date:   Mon, 25 Jul 2022 21:15:58 +0800
Message-ID: <20220725131558.13219-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain; charset="N"
Content-Transfer-Encoding: 8bit
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Some editor cannot display ‘0’ ‘1’ in correct format.
Change it to '0' '1' for most editor can display.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..4ffb344bcb46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -760,14 +760,14 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 mask)
 	 * From the UFSHCI specification: "UTP Transfer Request List CLear
 	 * Register (UTRLCLR): This field is bit significant. Each bit
 	 * corresponds to a slot in the UTP Transfer Request List, where bit 0
-	 * corresponds to request slot 0. A bit in this field is set to ‘0’
+	 * corresponds to request slot 0. A bit in this field is set to '0'
 	 * by host software to indicate to the host controller that a transfer
 	 * request slot is cleared. The host controller
 	 * shall free up any resources associated to the request slot
-	 * immediately, and shall set the associated bit in UTRLDBR to ‘0’. The
+	 * immediately, and shall set the associated bit in UTRLDBR to '0'. The
 	 * host software indicates no change to request slots by setting the
-	 * associated bits in this field to ‘1’. Bits in this field shall only
-	 * be set ‘1’ or ‘0’ by host software when UTRLRSR is set to ‘1’."
+	 * associated bits in this field to '1'. Bits in this field shall only
+	 * be set '1' or '0' by host software when UTRLRSR is set to '1'."
 	 */
 	ufshcd_writel(hba, ~mask, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
-- 
2.18.0


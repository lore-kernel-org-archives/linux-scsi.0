Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C744CCA48A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 13:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242486AbiGSNBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242720AbiGSM73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 08:59:29 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDFF45F50;
        Tue, 19 Jul 2022 05:24:51 -0700 (PDT)
X-QQ-mid: bizesmtp78t1658233483twpi7lca
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 20:24:42 +0800 (CST)
X-QQ-SSF: 01000000002000F0U000B00A0000020
X-QQ-FEAT: ALw5QuVtm4UX2aTdS17ZK0YQ2xqnbVeYGWn3oAzX2DoWmUeKiwX40WlbeDxHB
        6oaiMq11D1GfurKB5HfDQdejRCDKhn4rC22Yobd0TFwanDXG3d7II1LPrfeCdcdkhHZq1fk
        HCMBsHBC6b39wIPABP4Jd7Jhoh+rPLLAnD84QVezmBWmWFbkuG0BGo4tErDR9aqBlMLuyhO
        BDu7iK6gymzFwS5/012H/uAT6I5nEcLXFyJqi+c8fKdZreOGfhAIuYDKBpqKb58X/7Fe2WV
        ks0JPRSo+PtfIECxjL7iaO/HXg2fyIc6g9Mig6bEL/drpYI07M0phuvNzir9WOalj4JeUu9
        exdbeYVwu4uW5hikDBKI6Ezplrl17eh6slMqFrG690AnMKYAud50rdbv5srwMkm4b8rMKYa
        BCfUPhBvXfM=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     sreekanth.reddy@broadcom.com
Cc:     sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] scsi: message: fusion: Fix comment typo
Date:   Sat, 16 Jul 2022 12:22:45 +0800
Message-Id: <20220716042245.35708-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double `only' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/message/fusion/mptbase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9b3ba2df71c7..86e7510d7614 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -518,7 +518,7 @@ mpt_reply(MPT_ADAPTER *ioc, u32 pa)
 
 	/* Map DMA address of reply header to cpu address.
 	 * pa is 32 bits - but the dma address may be 32 or 64 bits
-	 * get offset based only only the low addresses
+	 * get offset based only the low addresses
 	 */
 
 	reply_dma_low = (pa <<= 1);
-- 
2.35.1


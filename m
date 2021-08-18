Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05342C432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 10:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11CD6108E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 10:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhHRKeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 06:34:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41058 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbhHRKdr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 06:33:47 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210818103302epoutp032fd8a407ac804a1593c2fe9b0b24e2d5~cYA7ddg1s0083800838epoutp03x
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 10:33:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210818103302epoutp032fd8a407ac804a1593c2fe9b0b24e2d5~cYA7ddg1s0083800838epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629282782;
        bh=4aiXT+GEVaX3PC1jXQ85xbsODWb/XUmXvvq3QVjF7xA=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=L6bCuWXx5RAwA4vnbprKmVB4brIVsVX07OInhHb6eE4/WqoIxoCa/xIPIMm3v/v8P
         i/aMrNHyujgAGX0w5Chp7NeFv8cIzZLrpd0d+AUy1o2k/Qk25I/tjR7pZ50zQbqHTl
         XxQ75AdaNRp+JUylkytcj2XGE+aI1HFyzZ8qUGyE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210818103301epcas3p3f00d398e34733791bbfd889d14f774cc~cYA7BEwr80952209522epcas3p3Q;
        Wed, 18 Aug 2021 10:33:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GqPP94dXTz4x9QB; Wed, 18 Aug 2021 10:33:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: ufshpb: Fix typo in comments
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01629282781634.JavaMail.epsvc@epcpadp4>
Date:   Wed, 18 Aug 2021 18:41:39 +0900
X-CMS-MailID: 20210818094139epcms2p745d70390a0e328f3ecc3b266f092c9f7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210818094139epcms2p745d70390a0e328f3ecc3b266f092c9f7
References: <CGME20210818094139epcms2p745d70390a0e328f3ecc3b266f092c9f7@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change "allcation" to "allocation"

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 9acce92a356b..bae98e197711 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -255,7 +255,7 @@ static bool ufshpb_test_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	/*
 	 * If the region state is active, mctx must be allocated.
 	 * In this case, check whether the region is evicted or
-	 * mctx allcation fail.
+	 * mctx allocation fail.
 	 */
 	if (unlikely(!srgn->mctx)) {
 		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-- 
2.17.1


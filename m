Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6245EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 03:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJSDpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 23:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJSDpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 23:45:40 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AA5DEF1C
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 20:45:37 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221019034532epoutp0368ccfbea7709bfefb907b1587a1c7ee4~fW6CO2aeA1439214392epoutp03K
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 03:45:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221019034532epoutp0368ccfbea7709bfefb907b1587a1c7ee4~fW6CO2aeA1439214392epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666151132;
        bh=Pacm9DFtavfzT6lgp8j/mjNE+GV6LEgkAK7hV4ylTto=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=u/7hA3vlj8zB8TPn/BnrIHYbqELk3oUSxLuLRyX7Qx9hhewc/RgeBaLmqWNOuS5Vf
         iu2j/PTXc8/BJ6CmIX58Nwncj5MHLMi2S7eacNm8XqqMYp2fCGRmDYCYUTRQ+yiwsl
         Ihek+FcQO0363GGE4IjLDrsUX8IYakCPWBYPUS5o=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20221019034531epcas2p45f39b22e6759e10bede35fe50d12579b~fW6BpaAMp0518705187epcas2p40;
        Wed, 19 Oct 2022 03:45:31 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Msc7v2fD5z4x9QF; Wed, 19 Oct
        2022 03:45:31 +0000 (GMT)
X-AuditID: b6c32a47-ac5b870000002127-55-634f72db120c
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.CD.08487.BD27F436; Wed, 19 Oct 2022 12:45:31 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Fix typo in comments
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735@epcms2p2>
Date:   Wed, 19 Oct 2022 12:45:30 +0900
X-CMS-MailID: 20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmme7tIv9kg89rBC0ezNvGZvHy51U2
        i9V3+9ksDj7sZLGY9uEns8XLQ5oWj24/Y7RYdGMbk8Xxk+8YLS7vmsNm0X19B5vF8uP/mBx4
        PC5f8fa4fLbUY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5DzaD3QzBXBEZdtkpCampBYppOYl
        56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAN2qpFCWmFMKFApILC5W0rez
        KcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjOmPzjHHPBJLaKf0uv
        sjQwtrN2MXJySAiYSFxbNpmxi5GLQ0hgB6PE+12nmbsYOTh4BQQl/u4QBjGFBcwktrV7g5QL
        CShJdC3cygxiCwsYSKybvgfMZhPQk5jy+w7YGBGBl8wSq/qfskHM55WY0f6UBcKWlti+fCsj
        hK0h8WNZLzOELSpxc/Vbdhj7/bH5UDUiEq33zkLVCEo8+LkbKi4p0XpmK9T8fIknN/uh5tdI
        LNj+GSquL3GtYyNYnFfAV2LKjkNgvSwCqhLbuy9C7XKReN31kwnEZhaQl9j+dg7Y68wCmhLr
        d+mDmBICyhJHbrHAfNKw8Tc7OptZgE+i4/BfuPiOeU+YIGw1iUcLtkBDWUbi4pxzUJ94SGw/
        spN1AqPiLEQ4z0JywyyEGxYwMq9iFEstKM5NTy02KjCGR21yfu4mRnCi1XLfwTjj7Qe9Q4xM
        HIyHGCU4mJVEeN2++CQL8aYkVlalFuXHF5XmpBYfYjQF+n4is5Rocj4w1eeVxBuaWBqYmJkZ
        mhuZGpgrifN2zdBKFhJITyxJzU5NLUgtgulj4uCUamCa4/E380YqW7LRVN9XTQGBx3ZoVE00
        vjJvfrLOWsON+xr3TajeE/ysoX1ZdmGBj94W5+jpMfuvN26/J3r+xhKRQsGd4Wx1uZUL38uy
        GsR9s/2wQIZb911hQNaXLTLzN7TuS1ItnePtca7a6Pcpgb/Vrw1UJ8zv3skYERC7oF6wtzjC
        4uNn31LNSI7wh5PXLtLauedWg82CA5MfMoet+H3szONFlu+ZFA6Kr3OV9t1+TtvXrVsrak9h
        t/61h7Hdkuem30wMvHSFq2sVZ0Df7Zai/IsTmzMVSuTeZ312+DN1X/teu7yGizy9Odf5bG7O
        EIxVXuN6Tq7y2JPnqbwS4T/eH1lzecNh5ikmaxf27opWYinOSDTUYi4qTgQAvV3P1z0EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735
References: <CGME20221019034530epcms2p2b10e072bb66b3fd6cdbe0e2423c11735@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change "drity" to "dirty".

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/ufs/core/ufshpb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index 3d69a81c5b17..14748f2c337b 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -383,7 +383,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	rgn = hpb->rgn_tbl + rgn_idx;
 	srgn = rgn->srgn_tbl + srgn_idx;
 
-	/* If command type is WRITE or DISCARD, set bitmap as drity */
+	/* If command type is WRITE or DISCARD, set bitmap as dirty */
 	if (ufshpb_is_write_or_discard(cmd)) {
 		ufshpb_iterate_rgn(hpb, rgn_idx, srgn_idx, srgn_offset,
 				   transfer_len, true);
-- 
2.17.1


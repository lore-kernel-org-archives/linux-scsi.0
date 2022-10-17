Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351FCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 09:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiJQJ63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 05:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiJQJ6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 05:58:25 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81BB5D120
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 02:58:22 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221017095816epoutp01366ab38e7a896741643e8c1aa8512d6f~e0s6MIzkj0741407414epoutp01T
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:58:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221017095816epoutp01366ab38e7a896741643e8c1aa8512d6f~e0s6MIzkj0741407414epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666000696;
        bh=WibRp7sZGBpviG504+PtLtKysfpSfKBHtaKxwIvQxv4=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=ant+w7v/HV97NCE2sxI50hEp0J6cwjI6mMQMKYebj5Vckoi237gAD7Mui2cdKvDW2
         +qdRAoZ5rXQB+ZVCVeR2QUhXs7ozI83w820yQMyXHwCRmXBX37ieZ7lCJHGvn10uFj
         ngM5YN9UXubam5uTfYnPTEOG8GR50rBhTlnmJeyI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20221017095816epcas2p111a20eff63ae8467348ccbe9f6b90339~e0s5o-1N70896308963epcas2p1W;
        Mon, 17 Oct 2022 09:58:16 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.101]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MrXVv5nFsz4x9Q2; Mon, 17 Oct
        2022 09:58:15 +0000 (GMT)
X-AuditID: b6c32a47-ac5b870000002127-4a-634d2737e88f
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.41.08487.7372D436; Mon, 17 Oct 2022 18:58:15 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Fix typo for register name in comments
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12@epcms2p1>
Date:   Mon, 17 Oct 2022 18:58:15 +0900
X-CMS-MailID: 20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmha65um+ywbZubYsH87axWbz8eZXN
        4uDDThaLaR9+Mlu8PKRp8ej2M0aL3v6tbBaLbmxjsri8aw6bRff1HWwWy4//Y7JYuvUmowOP
        x+Ur3h4TFh1g9Gg5uZ/F4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCOqGybjNTElNQihdS8
        5PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBjlRTKEnNKgUIBicXFSvp2
        NkX5pSWpChn5xSW2SqkFKTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGTcW/WUueMZa8fXO
        HPYGxkcsXYycHBICJhI9rZ+Zuxi5OIQEdjBKLDy9ibWLkYODV0BQ4u8OYZAaYQEPiTMnXjGC
        2EICShJdC7cyQ8QNJNZN3wNmswnoSUz5fYcRZI6IwG9middbFrBCLOCVmNH+FGqZtMT25VsZ
        IWwNiR/LepkhbFGJm6vfssPY74/Nh6oRkWi9dxaqRlDiwc/dUHFJidYzW9kg7HyJJzf7oebX
        SCzY/hkqri9xrWMjWJxXwFfiy8tWsPksAqoSZ+c1M4L8KCHgIvFjmjhImFlAXmL72znMIGFm
        AU2J9bv0ISqUJY7cYoF5pGHjb3Z0NrMAn0TH4b9w8R3znjBB2GoSjxZsgQaCjMTFOeegHvGQ
        +Dp5ItMERsVZiHCeheSGWQg3LGBkXsUollpQnJueWmxUYAyP2uT83E2M4FSr5b6DccbbD3qH
        GJk4GA8xSnAwK4nwun3xSRbiTUmsrEotyo8vKs1JLT7EaAr0/ERmKdHkfGCyzyuJNzSxNDAx
        MzM0NzI1MFcS5+2aoZUsJJCeWJKanZpakFoE08fEwSnVwLRX/JMuc2/pzY1CPGrik2frrX1r
        93XNXNH3wdsO3Ll9XMu/t+rMspu6dxPPH6/5cqptB+sHtqLc9YXK3L09QlY3ekrTK5XfaB+1
        WDzrtnnBkhp3m4Xzwgzmib/tYzQIWFd0W/LWzX5evniPG9dXHwtcoqBy/0DZrM/H/JZfdLD6
        XuqluoqlOldW/mHTxJrqiTsXFR5g8Hxa/yegv3XTuTuL+z1FuywU1x1byP2yat8/1pimwM/L
        pujMU3pxc4FI0dnSz7IPlJb+zNG+/bFV1WLSqQPsK9UuXt59PzhcsFzz5a6y6dyevyL3lKXq
        bP5heKJw+8HJdbu+yj48MPG8kVhgTpTZ23fsy/7lcms0p15QYinOSDTUYi4qTgQAFz4oUj4E
        AAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12
References: <CGME20221017095815epcms2p110e3421b99bb9a937620b4d065d0ed12@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change "UTRMLCLR" to "UTMRLCLR".
The meaning is "UTP Task Management Request List CLear Register"

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c15cbc737b4..9c5f100b488c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -772,7 +772,7 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 mask)
 }
 
 /**
- * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
+ * ufshcd_utmrl_clear - Clear a bit in UTMRLCLR register
  * @hba: per adapter instance
  * @pos: position of the bit to be cleared
  */
-- 
2.17.1


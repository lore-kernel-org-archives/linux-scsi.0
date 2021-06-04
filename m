Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E55C47082
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 03:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF75613FA
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 03:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFDD04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 23:26:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54889 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFDD0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 23:26:55 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210604032502epoutp03aca601e2e54db385998e7d3604a1b651~FQy1W8lYn1660316603epoutp03x
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 03:25:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210604032502epoutp03aca601e2e54db385998e7d3604a1b651~FQy1W8lYn1660316603epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622777102;
        bh=Yt1Sj2XXi3KmtfJpqVNJUKrRMWphSHZV63OZL/+hits=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=Zs9xH+k+RKv2QWOV3EJO9x0peo0Pli91v5kv3IbMVyNnRlvavMOdLanPDDxzDwGVW
         C1Xn4p8FKXUZnBA+EDduUIhhUfR3uu7u1pF37163c3jwLGdDz6rdNGFCOWmVTR/wnV
         w36QBYUuIJ4A5I//S1UVl+QttqohNeYjpxhAH3dk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210604032501epcas3p13d54e44d42cd297259df00cc67b1ca77~FQy0mG8YT2751327513epcas3p13;
        Fri,  4 Jun 2021 03:25:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4Fx7Rx5lxwz4x9Q1; Fri,  4 Jun 2021 03:25:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Remove repeated word
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01622777101796.JavaMail.epsvc@epcpadp3>
Date:   Fri, 04 Jun 2021 11:40:38 +0900
X-CMS-MailID: 20210604024038epcms2p2801b5b2e10e93ba4ecf5f6069bf862f1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210604024038epcms2p2801b5b2e10e93ba4ecf5f6069bf862f1
References: <CGME20210604024038epcms2p2801b5b2e10e93ba4ecf5f6069bf862f1@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove repeated word "for" in comments.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index af527e77fe66..aca475b5e27a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2809,7 +2809,7 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
-	 * wait for for h/w to clear corresponding bit in door-bell.
+	 * wait for h/w to clear corresponding bit in door-bell.
 	 * max. wait is 1 sec.
 	 */
 	err = ufshcd_wait_for_register(hba,
-- 
2.17.1

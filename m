Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE39C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 12:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9088A6124C
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 12:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbhERMQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 08:16:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42658 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242081AbhERMQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 08:16:22 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210518121502epoutp028d3d24970a30c5ba00c049766f4f3099~AKDu6Mg3M0277102771epoutp02V
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 12:15:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210518121502epoutp028d3d24970a30c5ba00c049766f4f3099~AKDu6Mg3M0277102771epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1621340102;
        bh=ftfW5RCRRu47HHcS4y6Q2kEbXts9hxGMQGCqRkXKY08=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=SF6w/nJPeoEZRdvM0Ec4ayadhZ7mWgr3boIcgrsqmDWw/Sev1gMrt10BXAchZRSby
         g3DFmSfiOZT3I9Sc2ib3hof9go4D/k0+0c8b0KFcBXlkaKNqlir6yvRTGEU11GphSN
         PuoIlsWHJaNGYc+6BXHnWyY1oQ+wrO431ys7kdhk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210518121502epcas3p2ce8d6e01799a46f093f1133310c4fcfc~AKDucjODJ2120221202epcas3p2k;
        Tue, 18 May 2021 12:15:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4Fkw1L2D5Jz4x9Pw; Tue, 18 May 2021 12:15:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Clean up white space
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "satyat@google.com" <satyat@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21621340102306.JavaMail.epsvc@epcpadp3>
Date:   Tue, 18 May 2021 21:12:17 +0900
X-CMS-MailID: 20210518121217epcms2p6b35173a078be7eb2cea2d80e2bbc1b00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210518121217epcms2p6b35173a078be7eb2cea2d80e2bbc1b00
References: <CGME20210518121217epcms2p6b35173a078be7eb2cea2d80e2bbc1b00@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

checkpatch reports the followings:

	ERROR: space prohibited before that ',' (ctx:WxW)
	#945: FILE: drivers/scsi/ufs/ufshcd.h:945:
	+int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
	                                  ^

	ERROR: space prohibited before that ',' (ctx:WxW)
	#945: FILE: drivers/scsi/ufs/ufshcd.h:945:
	+int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
	                                                   ^
remove unnecessary whitespace in ufshcd.h

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b8b4fe2b6bd5..791fb86409c2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -942,7 +942,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
-int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
+int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
 int ufshcd_link_recovery(struct ufs_hba *hba);
 int ufshcd_make_hba_operational(struct ufs_hba *hba);
 void ufshcd_remove(struct ufs_hba *);
-- 
2.17.1

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C5FC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 09:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44F46142E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 09:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhEMJDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 05:03:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30575 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhEMJBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 05:01:21 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210513090002epoutp0499b808d0be9b629e96ef1818b6267b9b~_lLDFnAH-1586115861epoutp04W
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 09:00:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210513090002epoutp0499b808d0be9b629e96ef1818b6267b9b~_lLDFnAH-1586115861epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620896402;
        bh=Vs63gqz+/TXRFMqr/QYcpMkMySWz64LQoVJF05N0H60=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=f+eRw09KUk9fyev6ZBdMnyqE+d5QdipHpGYXHiBazIFEYn37FUQpghv7wOveBNsmN
         4xMs3GcFZvtr0r4uwWQ0dYiwp05iJ9HX6cSA1KVuJurWzQpCuNK4i8QszUJ3ZPvaX2
         t/epAIGOw/a0VUcmxxTuQX/iXbMGB9C7cPkXQpH8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210513090002epcas3p4f3534836b1efd1894a610a158d8d36df~_lLCfcehG3160431604epcas3p4D;
        Thu, 13 May 2021 09:00:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4Fglwf0bg7z4x9Px; Thu, 13 May 2021 09:00:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: sysfs: remove redundant parenthesis
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
        Keoseong Park <keosung.park@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01620896402035.JavaMail.epsvc@epcpadp3>
Date:   Thu, 13 May 2021 17:53:20 +0900
X-CMS-MailID: 20210513085320epcms2p87452b605eb1353caaf1add0b5488c88b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210513085320epcms2p87452b605eb1353caaf1add0b5488c88b
References: <CGME20210513085320epcms2p87452b605eb1353caaf1add0b5488c88b@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes unnecessary parenthesis in ufshcd_is_wb_flags/attrs()

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index d337839c19dc..4807d218b16c 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -724,8 +724,8 @@ static const struct attribute_group ufs_sysfs_string_descriptors_group = {
 
 static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
 {
-	return ((idn >= QUERY_FLAG_IDN_WB_EN) &&
-		(idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8));
+	return idn >= QUERY_FLAG_IDN_WB_EN &&
+		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
 }
 
 #define UFS_FLAG(_name, _uname)						\
@@ -793,8 +793,8 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 
 static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 {
-	return ((idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS) &&
-		(idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE));
+	return idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
+		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
 #define UFS_ATTRIBUTE(_name, _uname)					\
-- 
2.17.1

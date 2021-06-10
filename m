Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1ABC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A54161278
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhFJEcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:32:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38032 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhFJEcB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:32:01 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210610043003epoutp04d7861d6706998b1372b95a5418677c96~HHjT_Hffs1894618946epoutp04H
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2021 04:30:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210610043003epoutp04d7861d6706998b1372b95a5418677c96~HHjT_Hffs1894618946epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623299403;
        bh=d09/O9l0nBcXXX5q4Uy02Kjm4SqkeJGzPdL/C98Hnhc=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=LwpE7NYVW28z30dJO87Xc8/cmJjwWS8DaIwJo4TxpkfrTHIF8IW0gT08X7fyeqPLH
         4cDQlooLtnt/BWmV9kJg9TtlEpuQ4mbXwQMgUUZBRmygWNgyzc1JRo7DxmdED7Tfso
         jRwgp9ecQf/yis7MIAeKicX2W67anhGJ+8oSVZeo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210610043002epcas3p2050dc502b0b38fcef3818d049a226029~HHjShrnVU0604806048epcas3p2o;
        Thu, 10 Jun 2021 04:30:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4G0rc974Vbz4x9Q0; Thu, 10 Jun 2021 04:30:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Add indent for code alignment
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
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01623299401994.JavaMail.epsvc@epcpadp3>
Date:   Thu, 10 Jun 2021 13:07:31 +0900
X-CMS-MailID: 20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30
References: <CGME20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add indentation to return statement.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8b1d0dad0764..97dfc6e94390 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -903,7 +903,7 @@ static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 	else
 		return false;
 #else
-return true;
+	return true;
 #endif
 }
 
-- 
2.17.1

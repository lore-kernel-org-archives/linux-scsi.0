Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CC1C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E4961359
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFKDUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 23:20:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30838 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhFKDUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 23:20:01 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210611031802epoutp0475eb6f5040ca715c2ea3a8b9073a21ef~HaNuFoD7J0614006140epoutp04U
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2021 03:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210611031802epoutp0475eb6f5040ca715c2ea3a8b9073a21ef~HaNuFoD7J0614006140epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623381482;
        bh=6RHPHfUm/f0dCH+/5kjfQhMB3OYUas1Lszo9TuKUNYY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=OdQD9vELo7xEx85RM2+XQpOGFNvIgbxj8k19Ok7Us0060j2nHF02+qy+Nu8gI0Jy8
         Cz9vRUaPGlQbEqUyemFFIuuLpVaCbcsO4opdZp0gs1lzJw2Ov0x2Nv/ZbjIFnWMwgo
         An5WLPKBhd+ZKAItGCMCeIwCz75MOryv85yGwujA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210611031801epcas3p36b196371cbaa7fcfe6e43a44ec645827~HaNtGQQql0460804608epcas3p3_;
        Fri, 11 Jun 2021 03:18:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4G1Qyd4Xntz4x9Q7; Fri, 11 Jun 2021 03:18:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     =?UTF-8?B?7KCV7JqU7ZWcKEpPVU5HIFlPSEFOKSBNb2JpbGUgU0U=?= 
        <yohan.joung@sk.com>, Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e540ec7b6d3e4adc97780fcdf87f46aa@sk.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01623381481630.JavaMail.epsvc@epcpadp4>
Date:   Fri, 11 Jun 2021 10:54:04 +0900
X-CMS-MailID: 20210611015404epcms2p263732e0109443a4319e5a77ef5092f97
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e
References: <e540ec7b6d3e4adc97780fcdf87f46aa@sk.com>
        <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
        <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
        <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h index 6e6a0252dc15..b1128b0ce486 100644
>--- a/drivers/scsi/ufs/ufshpb.h
>+++ b/drivers/scsi/ufs/ufshpb.h
>@@ -30,19 +30,29 @@
> #define PINNED_NOT_SET                                U32_MAX
> 
> /* hpb support chunk size */
>-#define HPB_MULTI_CHUNK_HIGH                        1
>+#define HPB_LEGACY_CHUNK_HIGH                        1
>+#define HPB_MULTI_CHUNK_LOW                        7
>+#define HPB_MULTI_CHUNK_HIGH                        128
> 
>According to the JEDEC spec, bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD can be set from 4kb to 1024kb. 
>The transfer length should be provided up to 1020kb or 1024kb.
>Why did you set HPB_MULTI_CHUNK_HIGH to 128? 
>It can sends the hpb command up to 512kb. 
>This doesn't seem to match the specs.

I'll fix it in the next patch.

Thanks,
Daejun

>Thanks
>Yohan.
> 
> 
>  

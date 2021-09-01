Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D93C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907116108E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbhIACJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 22:09:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14328 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhIACJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 22:09:02 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210901020805epoutp0430ef7ae9d2b0a3d40010ccd36b9b3ee1~gkKC190HE1377113771epoutp04E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2021 02:08:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210901020805epoutp0430ef7ae9d2b0a3d40010ccd36b9b3ee1~gkKC190HE1377113771epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630462085;
        bh=0kFO7Rz9JYkOhgKVXFWXP3pObUCIGbv4Xk00n5yHx7U=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=D0nWRRWEE8tF1acBQ+bnnM11mv3fUk94QTAosu1SmOykGntsfFGTnPp8cM+K2LIPp
         wU/LfbMILqsVcsTIaUT+IgrduewDqpKJ0qrevDy1dKLgNdqf2ZJR4V9Va3wlIfaHRy
         caZdcClw3w3fn6AA3jOx6IM0IZ+p80OzXJAUkb6I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210901020803epcas3p13f87323d38d206506bbfe508e4399c70~gkKBeAcYW0690206902epcas3p1B;
        Wed,  1 Sep 2021 02:08:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GznX31nJ2z4x9QF; Wed,  1 Sep 2021 02:08:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2] scsi: ufs: ufshpb: Remove unused parameters
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     ChanWoo Lee <cw9316.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     wonsuk Jung <grant.jung@samsung.com>,
        Jin-Tae Jang <jt77.jang@samsung.com>,
        Doo-Hyun Hwang <dh0421.hwang@samsung.com>,
        Seunghui Lee <sh043.lee@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210901004620.29929-1-cw9316.lee@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21630462083241.JavaMail.epsvc@epcpadp4>
Date:   Wed, 01 Sep 2021 11:02:19 +0900
X-CMS-MailID: 20210901020219epcms2p30d291dffa58f8cca05d580cbddd60d37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c
References: <20210901004620.29929-1-cw9316.lee@samsung.com>
        <CGME20210901005350epcas1p10781b465ef299afd8b2f69e78b39cf5c@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi ChanWoo Lee,

>From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
>The following parameters are not used in the function.
>So, remove unused parameters.
> 
>*func(): ufshpb_set_hpb_read_to_upiu
> -> struct ufshpb_lu *hpb
> -> u32 lpn
> 
>Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>

Please add Bart's tag above your signed-off tag.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

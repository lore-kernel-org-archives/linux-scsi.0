Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E207CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 07:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78919206A1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 07:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uG114BTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGIHsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 03:48:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51982 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgGIHsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 03:48:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200709074803epoutp04efb6c277f96498472df685559a34a3f8~gBgQyASKc0294202942epoutp04d
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 07:48:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200709074803epoutp04efb6c277f96498472df685559a34a3f8~gBgQyASKc0294202942epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594280883;
        bh=H+gBelzmZGb0OTapRZFbisJqPHe8bRUlzSVUDx0UcSg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=uG114BTfWGTAp7/dVVIKrOGYogfSNuARBO3zIFkFmJoluDXfD5Ub54mHmvf/piegG
         5I2oZ3TSsUw2yhbnC38Na1MRwBxGXMnbJAvBaUpqZSsM/EEG/lTVargKrzGh9vV7gi
         iTrIbsXnuQq7yRrjZWs1NyDlkXkn1knwdtAAgLDY=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200709074802epcas1p2e807de6d011ab9e2aa4398121442e08a~gBgQXL89G3205832058epcas1p2Z;
        Thu,  9 Jul 2020 07:48:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
Date:   Thu, 09 Jul 2020 16:29:01 +0900
X-CMS-MailID: 20200709072901epcms2p4da87414f3f3af8045a19c032544383fd
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4
References: <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hello,
> > 
> > Just a gentle reminder that I'd like some feedback.
> > Any suggestions here?
> If no-one objects, I think you can submit your patches for review as non-RFC.
> 
[PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
~~~~~~
It is non-RFC version.

Thanks,
Daejun.

Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8233C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 02:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C9220835
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 02:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WL/XrC4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFLC2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 22:28:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14585 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgFLC2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 22:28:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200612022802epoutp0293860fbe6f3c3a722212a044da87b66d~XquJ1spgr1176611766epoutp02P
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 02:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200612022802epoutp0293860fbe6f3c3a722212a044da87b66d~XquJ1spgr1176611766epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591928882;
        bh=gSUTsSh3Ap5sXaWepOAtrNN6Qrvvl5EFnfEzOzIMhdc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=WL/XrC4GK9yVJ83q2y6O7UOIRdQfJs3vUzToiAbI2pluq3D8f4XK2R7asKcN7Vu0r
         YD+ggajeTGoLGWKhaw7Jh3SloXxcmk8pGI4yjI5OHRi7K5c36nD7C/JYYqxgMC+uV4
         6o4ZChfY+dqxNZWJzmPmie9ZxHtLzb0nvcJpNN+4=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200612022802epcas1p443bca7f66a92407e8fbb9339595ff6be~XquJCLNeD1155711557epcas1p4o;
        Fri, 12 Jun 2020 02:28:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB4640638EAF31B0E3D11256DBFC820@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21591928882027.JavaMail.epsvc@epcpadp2>
Date:   Fri, 12 Jun 2020 11:25:20 +0900
X-CMS-MailID: 20200612022520epcms2p4b7c793427e53eda94ab2d1334e0b38f8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB4640638EAF31B0E3D11256DBFC820@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB46404CA953E4006BDCC61A65FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
        <1431530910.81591664283090.JavaMail.epsvc@epcpadp2>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=C2=A0I think this module parameter makes its first appearance in patch 4/=
5 - so maybe there?

OK, I will write module parameter in patch message 4/5.

Thanks,
Daejun

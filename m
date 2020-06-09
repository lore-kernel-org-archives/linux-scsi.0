Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41640C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0758120760
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HW2Z9q9s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgFIA6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27011 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbgFIA6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200609005803epoutp0226c150f86b2b88ab0d5be6340aa879d4~Wujt_gn5B0345903459epoutp02O
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200609005803epoutp0226c150f86b2b88ab0d5be6340aa879d4~Wujt_gn5B0345903459epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664283;
        bh=53LlOopkFAZwy0SS08Z6bbyhmIN5aDKJdXm2yAPy/ss=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=HW2Z9q9s7KS8h3n/1PyyLMBs8vzZxffPhmW5KyPyejQLxQs7WKnQDlYEqOgZ290If
         mtrsp6rq/rs+JmOTl9YH6YGcMUxsyJkLPCDKPvmn5ECK7i1XglpQjiWMqg8FW/IJj+
         keicX7VO76/sS2wdkuZXbOOi52CI3/iHoCF0/mEY=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005802epcas1p4ee83ccf3c1fdee73406a94a473a013ea~WujtqKQBx1777417774epcas1p41;
        Tue,  9 Jun 2020 00:58:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: RE: [RFC PATCH 0/5] scsi: ufs: Add Host Performance Booster
 Support
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
In-Reply-To: <SN6PR04MB4640DC01229F2073C2BD3103FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41591664282662.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:49:34 +0900
X-CMS-MailID: 20200609004934epcms2p4709b3121e78abd3e2595e1a532227e5d
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB4640DC01229F2073C2BD3103FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p4>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I appreciate your insightful comments.
 =20
> we propose  --> jedec spec XXX proposes =E2=80=A6
> and here you also disclose what version of the spec are you supporting
I will change to "JESD220-3 (HPB v1.0) proposes".
This patch supports HPB version 1.0.

> Like Bart, I am not sure that this extra module is needed.
> It only makes sense if indeed there are some common calls that can be sha=
red by several features.
> There are up to now 10 extended features defined, but none of them can sh=
are a common api.
> What other features can share this additional layer?  And how those ops c=
an be reused?
> If you have some future implementations in mind, you should add this api =
once you'll add those.
We added UFS feature layer with several callbacks to important parts of the=
 UFS control flow.
Other extended features can also be implemented using the proposed APIs.
For example, in WB, "prep_fn" can be used to guarantee the lifetime of UFS =
by updating the amount of write IO used as WB.
And reset/reset_host/suspend/resume can be used to manage the kernel task f=
or checking lifetime of UFS.

> This 2017 study, is being cited by everyone, but does not really describe=
s it's test setup to its details.
> It  does say however that they used a 16MB subregions over a range of 1GB=
,
> which can be covered by a 64 active regions, Even for a single subregion =
per region.
> Meaning no eviction should take place, thus HPB overhead is minimized.
> Do we have a more recent public studies that supports those impressive fi=
gures?
There are no other public studies currently.
However, when using HPB, there is an internal report that read latency is i=
mproved in android=20
user-case scenarios, as well as in the benchmarks.

Thanks,
Daejun


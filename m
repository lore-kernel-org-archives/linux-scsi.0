Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E08FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6145420814
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 00:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jcz/rVGi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgFIA6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:58:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27025 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730624AbgFIA6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 20:58:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200609005803epoutp02fdd4fcbece0979c8661af6e501779a59~WujuOfe5g0262802628epoutp02O
        for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2020 00:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200609005803epoutp02fdd4fcbece0979c8661af6e501779a59~WujuOfe5g0262802628epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591664283;
        bh=gMRsfepAEoh9eRvqw8xag4zsD3/d5Ax1hD88Kp8zmU4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=jcz/rVGi559IhdZkRfrQjmMHxTV1fWNeQO48Kcrhm8MV2UBO3aLjwk8HQBDTp4vSM
         s8MbTDOImauZff1G9bRBHu+vj/HglnozX+GHJV10IE5QVpHpU8tJScDCdmZK4ebkNO
         JJS6x1ztXF/fCjY51vjpPn6Nl0r7ziQkvUyBattg=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200609005802epcas1p356e4cc9fdb9f806447c28f2df725407c~Wujt4vyyD1120311203epcas1p3b;
        Tue,  9 Jun 2020 00:58:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH 1/5] scsi: ufs: Add UFS feature related parameter
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
In-Reply-To: <SN6PR04MB46403840179D1962FCEC363BFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1239183618.61591664282897.JavaMail.epsvc@epcpadp2>
Date:   Tue, 09 Jun 2020 09:51:12 +0900
X-CMS-MailID: 20200609005112epcms2p1afd6a9a10521c75af95e4d6340b847a7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882
References: <SN6PR04MB46403840179D1962FCEC363BFC870@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
        <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
        <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p1>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Maybe also add bit7 to the enum of dExtendedUFSFeaturesSupport ?
OK, I will.

Thanks,
Daejun.

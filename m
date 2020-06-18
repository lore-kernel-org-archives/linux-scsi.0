Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0680C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC3422229
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uDsBhGjr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732458AbgFRBpF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:45:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21412 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732149AbgFRBpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 21:45:04 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200618014502epoutp04f1cdcd4ec8b87fb98451f07f805fe3d8~ZgAUP0jdp0372703727epoutp04b
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2020 01:45:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200618014502epoutp04f1cdcd4ec8b87fb98451f07f805fe3d8~ZgAUP0jdp0372703727epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592444702;
        bh=twolrlHaZZVZpdlkPRS2+xEnnvzq2S5IOwmKy67vMX4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=uDsBhGjrRXcjR4JP5mreRbiUTAIHbmetXQVUyxbABdCZoVN2pS1504A7XnEDvfRNp
         mVEgxHecrMRIl6QFvDdqk9NH0vYPdzq4qnfoh1oxLG2+IxFHz69HBPrm+0bDa/Cmpq
         HL2Rc3/wdobv8Ow9b37LF1/7U5HyLeMW48w84ujc=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200618014501epcas1p41a295123d2f95e6df8415d2e04975748~ZgATuq7Dp1323913239epcas1p4q;
        Thu, 18 Jun 2020 01:45:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
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
In-Reply-To: <SN6PR04MB4640350209C30F578945492CFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592444701916.JavaMail.epsvc@epcpadp1>
Date:   Thu, 18 Jun 2020 09:53:44 +0900
X-CMS-MailID: 20200618005344epcms2p506001ce6c5958d65980bc9414d411695
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <SN6PR04MB4640350209C30F578945492CFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
> > +                             struct ufshpb_dev_info *hpb_dev_info)
> > +{
> > +       int ret;
> > +
> > +       spin_lock_init(&hpb->hpb_state_lock);
> > +
> > +       ret = ufshpb_alloc_region_tbl(hba, hpb);
> > +       if (ret)
> > +               goto release_m_page_cache;
> This label is added only on 4/5
> 
> > +static int __init ufshpb_init(void)
> > +{
> > +       unsigned int pool_size;
> Unused variable
> 
> > +       int ret;
> > +
> > +       ret = driver_register(&ufshpb_drv.drv);
> > +       if (ret)
> > +               pr_err("ufshpb: driver register failed\n");
> > +
> > +       return ret;
> > +}

OK, I will fix it.

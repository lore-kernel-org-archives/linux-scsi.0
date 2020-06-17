Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863BAC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E1F207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 11:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="slufTE79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQL6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 07:58:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54221 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgFQL6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 07:58:05 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200617115802epoutp036ee7fc947b3c8680a2d7cbf4954d8c24~ZUuP7_ig-1115511155epoutp03F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2020 11:58:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200617115802epoutp036ee7fc947b3c8680a2d7cbf4954d8c24~ZUuP7_ig-1115511155epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592395082;
        bh=z/9+1ybUONTNPwmt/FJ5Ns8irr9TIstMcjxiQL4SBfs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=slufTE79UrRN8v+yDmkRK3topjC8Hf/5shgSEEsphwCN1KA4YdiuoliavNZSLsbmu
         UmE/euKltti7Q5bvm2YrdCofWQN27GXuayPOPQHgGFvqecPLAinKptXWoqvZ+g0RTK
         3wtBh8KFPl7V7p16Ru6GK8lRtqP4a0nRvVvzQ5bs=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200617115801epcas1p37d5545b6b352dc1d5c44992d6260d0d1~ZUuPcSeQ01421314213epcas1p3R;
        Wed, 17 Jun 2020 11:58:01 +0000 (GMT)
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
In-Reply-To: <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592395081831.JavaMail.epsvc@epcpadp2>
Date:   Wed, 17 Jun 2020 19:30:26 +0900
X-CMS-MailID: 20200617103026epcms2p5ca0dd6f6d540bad48967d7777fa6a530
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> > This is a patch for the HPB module.
> > The HPB module queries UFS for device information during initialization.
> > We added the export symbol to two functions in ufshcd.c to initialize
> > the HPB module.
> > 
> > The HPB module can be loaded or built-in as needed.
> > The mininum size of the memory pool used in the HPB module is
> Typo minimum
> 
> > implemented
> > as a module parameter, so that it can be configurable by the user.
> > 
> > To gurantee a minimum memory pool size of 4MB:
> > $ insmod ufshpb.ko ufshpb_host_map_kbytes=4096
> You are going through a lot of troubles to make it a loadable module.
> What are, in your opinion, the pros and cons of this design decision?

In my opinion...

pros:
1. A user can unload an unnecessary module when there is an insufficient
memory situation (HPB case).
2. Since each UFS vendor has a different way of implementing UFS features,
it can be supported as a separate module. Otherwise, many quirks must
be attached to module, which is not desirable way.
3. It is possible to distinguish parts that are not necessary for essential
ufs operation.
4. It is advantageous to implement the latest functions according to the
development speed of UFS.

cons:
1. It is difficult work to be implemented as a module.
2. Modifying "ufsfeature.c" is required to implement the feature that can
not supported by the exsiting "ufsf_operation".

Thanks,
Daejun

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7824C4332B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8218564DF8
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhBDA6x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:58:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24910 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbhBDA6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 19:58:49 -0500
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210204005803epoutp03af39a1fde5191b12f6d1d7a7fc6c4e1a~gZYPK_Gra0466604666epoutp03f
        for <linux-scsi@vger.kernel.org>; Thu,  4 Feb 2021 00:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210204005803epoutp03af39a1fde5191b12f6d1d7a7fc6c4e1a~gZYPK_Gra0466604666epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612400283;
        bh=1WUrftmjM/+qz4pmRX82GVJib7UNGm1QV0Sm/EH200s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=d9ar1wgn19b89JBWALEmh7llXpTbtZt08T/H5r/cWMcsFnjQNy4nH71Y98fBG8YkB
         1pTvq73LI/kjtHtShZohbBRITI6BvPDSw8x8nv71+FOFuqWNjYw/3fu3OhwSO2kF0/
         VGEn9bOgqXtHqIbwFyqXG5bBw7qdyFT5JKYQF1pM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210204005802epcas3p18b477398667eb6ffbb7e2ffeac420318~gZYOeROqI0125501255epcas3p15;
        Thu,  4 Feb 2021 00:58:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4DWKsk3lgXz4x9QF; Thu,  4 Feb 2021 00:58:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65754E2E4FBC24CD6AC5F17CFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21612400282508.JavaMail.epsvc@epcpadp4>
Date:   Thu, 04 Feb 2021 09:48:09 +0900
X-CMS-MailID: 20210204004809epcms2p8ba311b86e8a276fd1bb5e17881e93056
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210202112157epcas2p3b04677e1380e0fa2c3f38217dfcba8bf
References: <DM6PR04MB65754E2E4FBC24CD6AC5F17CFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210202083007.104050-1-avri.altman@wdc.com>
        <20210202083007.104050-10-avri.altman@wdc.com> <YBk0s1Y4DOXuup+q@kroah.com>
        <CGME20210202112157epcas2p3b04677e1380e0fa2c3f38217dfcba8bf@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > - timeout_polling_interval_ms - the frequency in which the delayed
> > >     worker that checks the read_timeouts is awaken.
> >=20
> > You create new sysfs files, but fail to document them in
> > Documentation/ABI/ which is where the above information needs to go :(
> Done.
> Will wait to see where Daejun chooses to document the stats entries, and =
follow.

I added all sysfs entries about UFS-specific descriptors but not about HPB
related things. I will add HPB related sysfs entries in the=20
Documentation/ABI/testing/sysfs-driver-ufs file in the next patch.

Thanks,
Daejun
=C2=A0
=C2=A0

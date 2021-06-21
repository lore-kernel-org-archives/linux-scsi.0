Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB71C48BE5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84BB60FEE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 07:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFUHnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 03:43:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38936 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFUHmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 03:42:18 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210621074002epoutp032c3655c59ebf53ef7ffa26c69c4ba5dd~KiPVTN_FY0406804068epoutp03K
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 07:40:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210621074002epoutp032c3655c59ebf53ef7ffa26c69c4ba5dd~KiPVTN_FY0406804068epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624261202;
        bh=7CVWvKbYsupnM50MrPVqHxyPixQFHkR5GWCIGMR1eBA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=k7oWvUzaSUxpppoyvOS+opGFTZc//S3Prf0msOxuaIdFqX5dWQN1epgZUZtEJ6OtD
         Pk9ND5Y/e5PmJD/S99gryQnprvFD9aFDBe4Sm548ybbaQO3mY534wHN3PUJj12UC2Y
         9RA2aD4PkwOnpiR+Z0gLlvzapSK0iZPu8JbAPxGI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210621074002epcas3p1a2472cc0dc48fa7a31d4c6916b3a65b7~KiPUlGc0P2147621476epcas3p13;
        Mon, 21 Jun 2021 07:40:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4G7hJL0Kp0z4x9Q4; Mon, 21 Jun 2021 07:40:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v11 12/12] scsi: ufshpb: Make host mode parameters
 configurable
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575BF2A411BDDF7832A844AFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21624261202059.JavaMail.epsvc@epcpadp3>
Date:   Mon, 21 Jun 2021 16:25:10 +0900
X-CMS-MailID: 20210621072510epcms2p400b6e831ece70a27562dc5c7c808c14a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210616113004epcas2p41cf111449e118965ae71aaaee1d3bd5c
References: <DM6PR04MB6575BF2A411BDDF7832A844AFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210616112800.52963-13-avri.altman@wdc.com>
        <20210616112800.52963-1-avri.altman@wdc.com>
        <2038148563.21624252502579.JavaMail.epsvc@epcpadp3>
        <CGME20210616113004epcas2p41cf111449e118965ae71aaaee1d3bd5c@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> > Hi Avri,
> > 
> > >diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> > b/Documentation/ABI/testing/sysfs-driver-ufs
> > >index d001f008312b..b10cecb286df 100644
> > >--- a/Documentation/ABI/testing/sysfs-driver-ufs
> > >+++ b/Documentation/ABI/testing/sysfs-driver-ufs
> > >@@ -1449,7 +1449,7 @@ Description:        This entry shows the maximum
> > HPB data size for using single HPB
> > >
> > >                 The file is read only.
> > >
> > >-What:                /sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
> > >+What:                /sys/bus/platform/drivers/ufshcd/*/flags/hpb_enable
> > 
> > This part seems to be the problem with my patch. I will correct it.
> Maybe if just another spin is really required?
OK, I will fix it in next re-spin and update the patches.
  
> > 
> > ...
> > 
> > >diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > >index ab66919f4065..6f2ded8c63b0 100644
> > >--- a/drivers/scsi/ufs/ufshpb.c
> > >+++ b/drivers/scsi/ufs/ufshpb.c
> > 
> > ...
> > 
> > >@@ -1697,6 +1704,7 @@ static void
> > ufshpb_normalization_work_handler(struct work_struct *work)
> > >         struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
> > >                                              ufshpb_normalization_work);
> > >         int rgn_idx;
> > >+        u8 factor = hpb->params.normalization_factor;
> > >
> > >         for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
> > >                 struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
> > >@@ -1707,7 +1715,7 @@ static void
> > ufshpb_normalization_work_handler(struct work_struct *work)
> > >                 for (srgn_idx = 0; srgn_idx < hpb->srgns_per_rgn; srgn_idx++) {
> > >                         struct ufshpb_subregion *srgn = rgn->srgn_tbl + srgn_idx;
> > >
> > >-                        srgn->reads >>= 1;
> > >+                        srgn->reads >>= factor;
> > >                         rgn->reads += srgn->reads;
> > 
> > How about changing it to "rgn->read >>=factor" and placing it outside the
> > for statement?
> I think zeroing rgn->reads before the loop and then rgn->reads += srgn->reads
> Making it clear, even as far as doc, that the region reads is the sum over its subregions.

OK, I understand your intention.

Thanks,
Daejun

>  
> Anyway, this code was introduced in patch 4, so I will fix it there only if you find it really necessary.
>  
> Thanks,
> Avri
>  
>  
>   

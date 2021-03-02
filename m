Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9C3C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70B764F1D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581388AbhCBSvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:51:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43874 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837913AbhCBJKq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 04:10:46 -0500
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210302091002epoutp02075310a1c71ff5f6e128764e68d87186~oe3N9vRgM0269302693epoutp02g
        for <linux-scsi@vger.kernel.org>; Tue,  2 Mar 2021 09:10:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210302091002epoutp02075310a1c71ff5f6e128764e68d87186~oe3N9vRgM0269302693epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614676202;
        bh=O31FVF9w9jaxLxUzUwYA/nvnejdGzFszkeQF7lstuOI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=WC6zzbMVz131or/4bzIVJNDvdKGamYMGVFuXVCE68I+EcKEfdxs2aq+BrE+EV91bi
         QVTIxBdMWOm6E3hCb61lw0ea7iZGfVVsGNwGGh2io1g+wbTXW3si0MjPt95jAiv0SY
         6RlVPYQpdRFy1w6zlBjJTQmCKTyaNKgVFS6pHIjo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210302091001epcas3p1c8d434a344e81ac45f34b96ab67e0f17~oe3NVbKVU3071630716epcas3p1F;
        Tue,  2 Mar 2021 09:10:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4DqWYP4gyhz4x9Q8; Tue,  2 Mar 2021 09:10:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v4 7/9] scsi: ufshpb: Add "Cold" regions timer
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
In-Reply-To: <DM6PR04MB657580F9080C31AB5AED1FDBFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21614676201654.JavaMail.epsvc@epcpadp3>
Date:   Tue, 02 Mar 2021 18:04:29 +0900
X-CMS-MailID: 20210302090429epcms2p443de88c14298f707577122e6a91b9a82
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210226083459epcas2p1862e3e2c18208074336cc9faf14a7139
References: <DM6PR04MB657580F9080C31AB5AED1FDBFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210226083300.30934-8-avri.altman@wdc.com>
        <20210226083300.30934-1-avri.altman@wdc.com>
        <878274034.81614673683390.JavaMail.epsvc@epcpadp4>
        <CGME20210226083459epcas2p1862e3e2c18208074336cc9faf14a7139@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,
> > 
> > Hi Avri,
> > 
> > > +static void ufshpb_read_to_handler(struct work_struct *work)
> > > +{
> > > +        struct delayed_work *dwork = to_delayed_work(work);
> > > +        struct ufshpb_lu *hpb;
> > > +        struct victim_select_info *lru_info;
> > > +        struct ufshpb_region *rgn;
> > > +        unsigned long flags;
> > > +        LIST_HEAD(expired_list);
> > > +
> > > +        hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
> > > +
> > > +        if (test_and_set_bit(TIMEOUT_WORK_PENDING, &hpb-
> > >work_data_bits))
> > > +                return;
> > > +
> > > +        spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> > > +
> > > +        lru_info = &hpb->lru_info;
> > > +
> > > +        list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
> > > +                bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
> > > +
> > > +                if (timedout) {
> > 
> > It is important not just to check the timeout, but how much time has passed.
> > If the time exceeded is twice the threshold, the read_timeout_expiries
> > value should be reduced by 2 instead of 1.
> Theoretically this shouldn't happened.
> Please note that POLLING_INTERVAL_MS << READ_TO_MS.
> Better add appropriate check when making those configurable.

OK, I agree.

Thanks,
Daejun

>  
> Thanks,
> Avri
> > 
> > > +                        rgn->read_timeout_expiries--;
> > 
> > Thanks,
> > Daejun
>  
>  
>  
>   

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66464C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BEB564DDA
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 08:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhBWI4c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 03:56:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26181 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbhBWI4a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 03:56:30 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210223085547epoutp04fc95053bd6b6eaaa601124515c146e6e~mVJx0EGeH0113201132epoutp04N
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2021 08:55:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210223085547epoutp04fc95053bd6b6eaaa601124515c146e6e~mVJx0EGeH0113201132epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614070547;
        bh=d0gOIuQUPCQxZRJQkKwdEW+V7cqTiJ3TqS4Et/IoMh0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=N4bhozeuwzxqXeZW26u1n+/z4gTOoWrYFW/aS9gqEu7fUOjuxp6R28MnzBgTw3NCR
         X7LHb9/zA4Gre7WqqU+UdLbjXLAXG/8qSZ9Og5MmjgdA9RSAI1nLf2GgCHuTYG0Pff
         05n8G8ubetl/nxGwAfdboUkfNEBdnV/sMIal+zO0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210223085546epcas2p33b74d382f135e0ff450998680399d4df~mVJw-Zg292016520165epcas2p3_;
        Tue, 23 Feb 2021 08:55:46 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DlCZ82xzRz4x9QB; Tue, 23 Feb
        2021 08:55:44 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-f9-6034c31019bf
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.4F.05262.013C4306; Tue, 23 Feb 2021 17:55:44 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: RE: RE: [PATCH v22 2/4] scsi: ufs: L2P map management for
 HPB read
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB657522A864655988A1430E56FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210223085543epcms2p32abd20cbc9dda715eab38a8a382d9057@epcms2p3>
Date:   Tue, 23 Feb 2021 17:55:43 +0900
X-CMS-MailID: 20210223085543epcms2p32abd20cbc9dda715eab38a8a382d9057
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmqa7AYZMEg1Vn2CwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gsFi3czeIg6nH5irfH5b5e
        Jo+ds+6ye0xYdIDRY//cNeweLSf3s3h8fHqLxaNvyypGj8+b5DzaD3QzBXBF5dhkpCampBYp
        pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAH2opFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQwMDIFqkzIyTgw1aXgEW/F
        y7fP2RoYz3J2MXJySAiYSJw8to6xi5GLQ0hgB6PE6Ql/mLsYOTh4BQQl/u4QBjGFBUIldl3T
        AykXElCSWH9xFjuILSygJ3Hr4RpGEJtNQEdi+on77CBjRARWsEhc/HWJDcRhFvjFJHHi8QdG
        iGW8EjPan7JA2NIS25dvBYtzCsRKnFm6lAkiriHxY1kvM4QtKnFz9Vt2GPv9sflQc0QkWu+d
        haoRlHjwczdUXFLi2O4PUHPqJbbe+QX2mIRAD6PE4Z23WCES+hLXOjaCHcEr4Ctxv/UuWDOL
        gKrE9VVXoJpdJPZ3LQOrZxaQl9j+dg44UJgFNCXW79IHMSUElCWO3GKBeath4292dDazAJ9E
        x+G/cPEd855ATVeTWPdzPdMERuVZiJCehWTXLIRdCxiZVzGKpRYU56anFhsVGCPH7SZGcGLX
        ct/BOOPtB71DjEwcjIcYJTiYlUR42e4aJQjxpiRWVqUW5ccXleakFh9iNAX6ciKzlGhyPjC3
        5JXEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C6WPi4JRqYJrVeuN7/UnDQp79
        Z5vuPc9wknnp4iakXm97Ik66KV28KKRnjuKO3wV6hvl3pOwe6dSZRE2cc0N6zSXBUo01Voky
        S9T5rSRX9Z9ZpKfIV1l8L66IfdeGylDmOoXJdkzzlXIeTm4JYpXe8sZVjinAVEOI7722y9/W
        k2eSF/EcX+Em+GS2QbTXj2PpCS//ejDel5boWrr2femsNaanwrZEZS+IbW3ddL6A98r1aXKd
        DE3JZ5MEH0Sz9vxaV3JiQoHoe5brKz3+zLmadYPhnr/B+x93vxUfUfa6cdB+oY/GlremQk3L
        xXR2lB/ZeyXfVsIsuszLadYMk8Aau2DdzoYqz6bXa28YXHnidCCynydLiaU4I9FQi7moOBEA
        QZfrAnUEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210222092907epcms2p307f3c4116349ebde6eed05c767287449
References: <DM6PR04MB657522A864655988A1430E56FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210223080043epcms2p83f813841174ade50ef97481b3f4cdef7@epcms2p8>
        <DM6PR04MB657508BC3F0D0240FDCBB043FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093050epcms2p6506a476c777785c6212cc80fc6158714@epcms2p6>
        <20210223083136epcms2p89ada047f0da1fb700ace8b4e3e396697@epcms2p8>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > +/*
> > > > + * This function will parse recommended active subregion information in
> > > > sense
> > > > + * data field of response UPIU with SAM_STAT_GOOD state.
> > > > + */
> > > > +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> > > > +{
> > > > +       struct ufshpb_lu *hpb;
> > > > +       struct scsi_device *sdev;
> > > > +       struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
> > > > +       int data_seg_len;
> > > > +       bool found = false;
> > > > +
> > > > +       __shost_for_each_device(sdev, hba->host) {
> > > > +               hpb = ufshpb_get_hpb_data(sdev);
> > > > +
> > > > +               if (!hpb)
> > > > +                       continue;
> > > > +
> > > > +               if (rsp_field->lun == hpb->lun) {
> > > > +                       found = true;
> > > > +                       break;
> > > This piece of code looks awkward, although it is probably working.
> > > Why not just having a reference to the hpb luns, e.g. something like:
> > > struct ufshpb_lu *hpb_luns[8] in struct ufs_hba.
> > > Less elegant - but much more effective than iterating the scsi host on every
> > completion interrupt.
> > 
> > How about checking (cmd->lun == rsp->lun) before the iteration?
> > Major case will be have same lun. And, it is hard to add struct ufshpb_lu
> > *hpb_luns[128]
> > in struct ufs_hba, because LUN can be upto 127.
> Oh - yes, 8 is for write booster.
> OK.  Whatever you think.

Then, I want to keep this code with adding code that checking same LUN for
fast path.
  
> However, I think there can be up to 32 regular luns,
> meaning UFS_UPIU_MAX_UNIT_NUM_ID need to be fixed as well.

OK, it can be fixed another patch.

Thanks,
Daejun

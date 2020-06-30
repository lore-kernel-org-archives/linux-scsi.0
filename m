Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F9AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B202078B
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 01:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mP4gYR51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgF3BIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 21:08:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61732 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbgF3BIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 21:08:04 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200630010802epoutp011fa2b43016b8d58090928952a74aa2d7~dLPb67lUU1575215752epoutp01M
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 01:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200630010802epoutp011fa2b43016b8d58090928952a74aa2d7~dLPb67lUU1575215752epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593479282;
        bh=YGYwcMBNENiLw/VSkmKokq8wHpV1ERBPe5z3zZVvL/s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mP4gYR51+KoKKg92dgCmtf8ZsRRWFXS++MBjPkqZdtwpnKwB25hRDmhdZw/nNw55N
         GoujU+NmSotv9T41A6rr7vX6wktg3cMumlbAXPc2UXMlAOtQIM/KwYp5HG/+bbxGIw
         AskZ0CKkwAUNf8LjgQ6HqmYAyCOWtfntXBtKRmbE=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200630010801epcas1p4b2643a224cc2759a324e973a0c6241e3~dLPbV2_iA1813518135epcas1p4o;
        Tue, 30 Jun 2020 01:08:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
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
In-Reply-To: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
Date:   Tue, 30 Jun 2020 10:05:38 +0900
X-CMS-MailID: 20200630010538epcms2p1672c42825cc42e92b2e3ec6bac79ee2b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200623010201epcms2p11aebdf1fbc719b409968cba997507114
References: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
        <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,
> On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > > Seems you intentionally ignored to give you comments on my
> > > suggestion.
> > > let me provide the reason.
> > 
> > Sorry! I replied to your comment (
> > https://protect2.fireeye.com/url?k=be575021-e3854728-be56db6e-0cc47a31cdf8-6c7d0e1e42762b92&q=1&u=https%3A%2F%2Flkml.org%2Flkml%2F2020%2F6%2F15%2F1492),
> > but you didn't reply on that. I thought you agreed because you didn't
> > send
> > any more comments.
> > 
> > 
> > > Before submitting your next version patch, please check your L2P
> > > mapping HPB reqeust submission logical algorithem. I have did
> > 
> > We are also reviewing the code that you submitted before.
> > It seems to be a performance improvement as it sends a map request
> > directly.
> > 
> > > performance comparison testing on 4KB, there are about 13%
> > > performance
> > > drop. Also the hit count is lower. I don't know if this is related
> > > to
> > 
> > It is interesting that there is actually a performance improvement. 
> > Could you share the test environment, please? However, I think
> > stability is
> > important to HPB driver. We have tested our method with the real
> > products and
> > the HPB 1.0 driver is based on that.
> 
> I just run fio benchmark tool with --rw=randread, --bs=4kb, --
> size=8G/10G/64G/100G. and see what performance diff with the direct
> submission approach.

Thanks!

> > After this patch, your approach can be done as an incremental patch?
> > I would
> > like to test the patch that you submitted and verify it.
> > 
> > > your current work queue scheduling, since you didn't add the timer
> > > for
> > > each HPB request.
> > 
> 
> Taking into consideration of the HPB 2.0, can we submit the HPB write
> request to the SCSI layer? if not, it will be a direct submission way.
> why not directly use direct way? or maybe you have a more advisable
> approach to work around this. would you please share with us.
> appreciate.

I am considering a direct submission way for the next version.
We will implement the write buffer command of HPB 2.0, after patching HPB 1.0.

As for the direct submission of HPB releated command including HPB write
buffer, I think we'd better discuss the right approach in depth before
moving on to the next step.

Thanks,
Daejun

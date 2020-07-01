Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF64C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9052E207F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:48:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YFBSv7Vj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGAAsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 20:48:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34453 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbgGAAsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 20:48:06 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200701004802epoutp03bd22a74a785979d28ec0c333a682ad14~denQ1CKbT1593615936epoutp03f
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2020 00:48:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200701004802epoutp03bd22a74a785979d28ec0c333a682ad14~denQ1CKbT1593615936epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593564482;
        bh=CNHOyk7FntBxbO6DreAHDvfBp5z8zIJ33mfiTt6PEOo=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=YFBSv7VjrWxwTug/llzdu5kvWGSpoSIK5GbGHzCx9tY1NixRa12bgqSJ6feYOPmMP
         +l//C8SRBBqQUtKLGXMMayBTqn5RqCon+5NQRjF2JFxIxpmDEg4Li6YZ0DogwZVuoe
         YbwQ3/qtLGnueccNjJvqaVWXcTNoemptidLCftNw=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200701004802epcas1p104acdf83bdd554594d94cf051eafaf3f~denQb2vuN3040330403epcas1p1N;
        Wed,  1 Jul 2020 00:48:02 +0000 (GMT)
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
In-Reply-To: <fd205a23c433aea43f846c37cf1f521c114cdd68.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1210830415.21593564482235.JavaMail.epsvc@epcpadp2>
Date:   Wed, 01 Jul 2020 09:14:34 +0900
X-CMS-MailID: 20200701001434epcms2p19a2315a4e4b55344ce1cacd79350408b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200623010201epcms2p11aebdf1fbc719b409968cba997507114
References: <fd205a23c433aea43f846c37cf1f521c114cdd68.camel@gmail.com>
        <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
        <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
        <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-06-30 at 10:05 +0900, Daejun Park wrote:
> > Hi Bean,
> > > On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > > > > Seems you intentionally ignored to give you comments on my
> > > > > suggestion.
> > > > > let me provide the reason.
> > > > 
> > > > Sorry! I replied to your comment (
> > > > 
> https://protect2.fireeye.com/url?k=be575021-e3854728-be56db6e-0cc47a31cdf8-6c7d0e1e42762b92&q=1&u=https%3A%2F%2Flkml.org%2Flkml%2F2020%2F6%2F15%2F1492
> > > > ),
> > > > but you didn't reply on that. I thought you agreed because you
> > > > didn't
> > > > send
> > > > any more comments.
> > > > 
> > > > 
> > > > > Before submitting your next version patch, please check your
> > > > > L2P
> > > > > mapping HPB reqeust submission logical algorithem. I have did
> > > > 
> > > > We are also reviewing the code that you submitted before.
> > > > It seems to be a performance improvement as it sends a map
> > > > request
> > > > directly.
> > > > 
> > > > > performance comparison testing on 4KB, there are about 13%
> > > > > performance
> > > > > drop. Also the hit count is lower. I don't know if this is
> > > > > related
> > > > > to
> > > > 
> > > > It is interesting that there is actually a performance
> > > > improvement. 
> > > > Could you share the test environment, please? However, I think
> > > > stability is
> > > > important to HPB driver. We have tested our method with the real
> > > > products and
> > > > the HPB 1.0 driver is based on that.
> > > 
> > > I just run fio benchmark tool with --rw=randread, --bs=4kb, --
> > > size=8G/10G/64G/100G. and see what performance diff with the direct
> > > submission approach.
> > 
> > Thanks!
> > 
> > > > After this patch, your approach can be done as an incremental
> > > > patch?
> > > > I would
> > > > like to test the patch that you submitted and verify it.
> > > > 
> > > > > your current work queue scheduling, since you didn't add the
> > > > > timer
> > > > > for
> > > > > each HPB request.
> > > 
> > > Taking into consideration of the HPB 2.0, can we submit the HPB
> > > write
> > > request to the SCSI layer? if not, it will be a direct submission
> > > way.
> > > why not directly use direct way? or maybe you have a more advisable
> > > approach to work around this. would you please share with us.
> > > appreciate.
> > 
> > I am considering a direct submission way for the next version.
> > We will implement the write buffer command of HPB 2.0, after patching
> > HPB 1.0.
> > 
> > As for the direct submission of HPB releated command including HPB
> > write
> > buffer, I think we'd better discuss the right approach in depth
> > before
> > moving on to the next step.
> > 
> 
> Hi Daejun
> If you need reference code, you can freely copy my code from my RFC v3
> patchset. or if you need my side testing support, just let me, I can
> help you test your code.
> 
It will be good example code for developing HPB 2.0.

Thanks,
Daejun

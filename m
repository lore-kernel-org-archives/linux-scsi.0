Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAEEC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E022073E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZJ5WGy4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgF2TQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:16:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61295 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731940AbgF2TQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:16:18 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200629061802epoutp02e3e973a80291db8dfca27a8010b3171d~c700runMW1235812358epoutp027
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 06:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200629061802epoutp02e3e973a80291db8dfca27a8010b3171d~c700runMW1235812358epoutp027
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593411482;
        bh=sl56te2E5w+y7+MVKmFRXqGfvxaXPtWrxS7ZTJ1zL70=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=ZJ5WGy4r6qpkd52JqIUHik7f+OrNJmAR6ZXmCcfqNjspxNyfGQKJdlWJoMKAZUtmN
         EfUS+ZLrTdvsmErApCqtdFoeBEJ4dvFt4cFnDhqp5T+LFOC0IybmNVqPgChPomkVyX
         4H5TP9DerJ1UGkQL8xCjkDPcY2eb+tIYPMmDlCnI=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200629061802epcas1p373384546ae4abaa322ad435d0652c1a1~c700LLWgk2623326233epcas1p3-;
        Mon, 29 Jun 2020 06:18:02 +0000 (GMT)
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
In-Reply-To: <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
Date:   Mon, 29 Jun 2020 15:15:46 +0900
X-CMS-MailID: 20200629061546epcms2p32cd92ff4570d6afb50bf9ee56623a53c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200623010201epcms2p11aebdf1fbc719b409968cba997507114
References: <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Seems you intentionally ignored to give you comments on my suggestion.
> let me provide the reason.
Sorry! I replied to your comment (https://lkml.org/lkml/2020/6/15/1492),
but you didn't reply on that. I thought you agreed because you didn't send
any more comments.


> Before submitting your next version patch, please check your L2P
> mapping HPB reqeust submission logical algorithem. I have did
We are also reviewing the code that you submitted before.
It seems to be a performance improvement as it sends a map request directly.

> performance comparison testing on 4KB, there are about 13% performance
> drop. Also the hit count is lower. I don't know if this is related to
It is interesting that there is actually a performance improvement. 
Could you share the test environment, please? However, I think stability is
important to HPB driver. We have tested our method with the real products and
the HPB 1.0 driver is based on that.
After this patch, your approach can be done as an incremental patch? I would
like to test the patch that you submitted and verify it.

> your current work queue scheduling, since you didn't add the timer for
> each HPB request.
There was Bart's comment that it was not good add an arbitrary timeout value
to the request. (please refer to: https://lkml.org/lkml/2020/6/11/1043)
When no timer is added to the request, the SD timout will be set as default
timeout at the block layer.

Thanks,
Daejun

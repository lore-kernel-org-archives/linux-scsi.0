Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A640C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 01:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339A860E74
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 01:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJ1BNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 21:13:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32650 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhJ1BNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 21:13:09 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211028011039epoutp03a14a0427c2c3edc4afdb0e8a491e47f9~yDJLaxLsQ3080430804epoutp03C
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 01:10:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211028011039epoutp03a14a0427c2c3edc4afdb0e8a491e47f9~yDJLaxLsQ3080430804epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635383439;
        bh=2MaSmnEv4JagGljHqpURj5ESzwpJIBS8SewdZGLIKmQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=ihBRFvDF99JaAMntJB3R64N/D7YbSDcMexxQ5oj58Nft+21Mp08wG+YeJ/Ae7ZJrU
         kxLU5w2Gc6XW8K1wec1Y2emoGcSLgIvke80LLQ5zZjQnHiZbKWGlOEbsRbTHOrR9w8
         PMDUd/MEhD6daj2hD7o/k64rTBUV9TmkhJBhETck=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211028011039epcas2p1f14667596b6a6f19db7046fdaa9ba1ec~yDJLESckM2945829458epcas2p1_;
        Thu, 28 Oct 2021 01:10:39 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.102]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HfnYJ5PgJz4x9Qk; Thu, 28 Oct
        2021 01:10:28 +0000 (GMT)
X-AuditID: b6c32a45-9a3ff7000000268c-ef-6179f87e3d3a
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.05.09868.E78F9716; Thu, 28 Oct 2021 10:10:22 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: mark HPB support as BROKEN
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <YXnx7EIFMTH8czLa@T590>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211028011022epcms2p1d2b2b1c56237c7cc1cca3a612f91b520@epcms2p1>
Date:   Thu, 28 Oct 2021 10:10:22 +0900
X-CMS-MailID: 20211028011022epcms2p1d2b2b1c56237c7cc1cca3a612f91b520
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmqW7dj8pEg6MH5SwezNvGZvHy51U2
        i9V3+9kspn34yWzx8pCmxcrVR5ksnqyfxWyxsZ/DYtKha4wWe29pW3Rf38Fmsfz4PyaLQ5Ob
        mRx4PS5f8faYNukUm8fls6Uem1Z1snnsvtnA5vHx6S0Wj/f7rrJ59G1ZxejxeZOcR/uBbqYA
        rqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygw5UU
        yhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BeYFesWJucWleel6eaklVoYGBkamQIUJ
        2Rm7Hx1mKpgiUrFu3R+2BsbH/F2MnBwSAiYS787fY+9i5OIQEtjBKLHrxQa2LkYODl4BQYm/
        O4RBaoQFrCT+zLzCCGILCShJrL84ix0iridx6+EasDibgI7E9BP3weIiAs4SM96fZQSZySxw
        hlli+t0PrBDLeCVmtD9lgbClJbYv3wrWzCmgIjH78kkmiLiGxI9lvcwQtqjEzdVv2WHs98fm
        M0LYIhKt985C1QhKPPi5GyouKXFs9weoOfUSW+/8AjtCQqCHUeLwzltQR+hLXOvYCHYEr4Cv
        xK5pG8DiLAKqEu17J4E9LyHgIvHnYQhImFlAXmL72znMIGFmAU2J9bv0ISqUJY7cYoH5qmHj
        b3Z0NrMAn0TH4b9w8R3znkBdpiax7ud6pgmMyrMQAT0Lya5ZCLsWMDKvYhRLLSjOTU8tNiow
        hMdtcn7uJkZwEtZy3cE4+e0HvUOMTByMhxglOJiVRHgvzytPFOJNSaysSi3Kjy8qzUktPsRo
        CvTkRGYp0eR8YB7IK4k3NLE0MDEzMzQ3MjUwVxLntRTNThQSSE8sSc1OTS1ILYLpY+LglGpg
        miz/83TqrWuV/Rcy1gi9ZVyfOmu2t9OaV7vXSCR732uet/O379kzQhNzy+qORy6z1WXdfEE4
        QHxpS/FiG47CKVKiAv6LYy/flKtI1FLbk8wudeNPgKlDZ2JnVNbmxAtL1r/lSKnp9HxqmxzW
        JbdSSOLs7CSv+u7qqbd23LKJ83pceOjz15PBLecsSv4+trl0b3LaQp3CPqnZrWEbp+yScwj/
        oZsWwfLwQPakex0RtiUqzRdbUyWe7Fb2ea+af+rUzgwtLfmGiYc/5dktyv7brcVf9vjNvpmm
        e08Len6RrJH8NO980I2Lx6z7Zc848k9bMctsrSfDA+XLakFblQ6EH3daoa95ec62FX8WvtIK
        UGIpzkg01GIuKk4EANqtVWFLBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211028004244epcas2p1f2212bf94ef861dfa6cd082c3cbb1803
References: <YXnx7EIFMTH8czLa@T590>
        <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211027052724.GA8946@lst.de>
        <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
        <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
        <YXlqSRLHuIFiMLY7@T590> <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
        <YXltPgRTxe+Xn66i@T590> <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
        <YXl3H39vHAj2+SSL@T590>
        <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
        <CGME20211028004244epcas2p1f2212bf94ef861dfa6cd082c3cbb1803@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

> On Wed, Oct 27, 2021 at 09:16:32AM -0700, Keith Busch wrote:
> > On Wed, Oct 27, 2021 at 11:58:23PM +0800, Ming Lei wrote:
> > > On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
> > > > 
> > > > Ming,
> > > > 
> > > > > request with scsi_cmnd may be allocated by the ufshpb driver, even it
> > > > > should be fine to call ufshcd_queuecommand() directly for this driver
> > > > > private IO, if the tag can be reused. One example is scsi_ioctl_reset().
> > > > 
> > > > scsi_ioctl_reset() allocates a new request, though, so that doesn't
> > > > solve the forward progress guarantee. Whereas eh puts the saved request
> > > > on the stack.
> > > 
> > > What I meant is to use one totally ufshpb private command allocated from
> > > private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
> > > directly, so forward progress is guaranteed if the blk-mq request's tag can be
> > > reused for issuing this private command. This approach takes a bit effort,
> > > but avoids tags reservation.
> > > 
> > > Yeah, it is cleaner to use reserved tag for the spawned request, but we
> > > need to know:
> > > 
> > > 1) how many queue depth for the hba? If it is small, even 1 reservation
> > > can affect performance.
> > > 
> > > 2) how many inflight write buffer commands are to be supported? Or how many
> > > is enough for obtaining expected performance? If the number is big, reserved
> > > tags can't work.
> > 
> > The original and clone are not dispatched to hardware concurrently, so I
> > don't think the reserved_tags need to subtract from the generic ones.
> > The original request already accounts for the hardware resource, so the
> > clone doesn't need to consume another one.
>  
> Yeah, that is why I thought the tag could be reused for the spawned(cloned)
> request, but it needs ufshpb developer to confirm, or at least
> ufshcd_queuecommand() can handle this situation. If that is true, it isn't
> necessary to use reserve tags, since the current blk-mq implementation
> requires to reserve real hardware tags space, which has to take normal
> tags.

It is true that pre-request can use the tag of READ request, but the READ
request should wait to completion of the pre-request command. However, if
the pre-request and the READ request are dispatched concurrently, it can
save the time to completion of the pre-request.

So I implemented as allocating new request and it has limit time to getting
pre-request, so it doesn't cause deadlock.

Thanks,
Daejun

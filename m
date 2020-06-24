Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FF7C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCDA02078D
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593019808;
	bh=h33gmGGByy2GPZrJ7tjNqx/Etm0E51dsYTshtyz2YhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=rhCsSHhPaP0f6YsfjvgGW3Pv+BWA3UWhry15FQb/3uRwRUhHRvBuk2djjLqKH9phN
	 JGbuVMhjnCiPXc+s3PT7CTYn2ttse8184K6cDwDO/hbtAVlmJACdWpAPF6r6GnOOKE
	 Cvi5GUHE664mgzPP1yrjprBkWHpce61ztsdYJg0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405463AbgFXRaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 13:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405429AbgFXRaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 13:30:05 -0400
Received: from localhost (unknown [171.61.66.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 156A52078D;
        Wed, 24 Jun 2020 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593019805;
        bh=h33gmGGByy2GPZrJ7tjNqx/Etm0E51dsYTshtyz2YhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yuRiI+ina71wDNranb8AwW9LaPmZDEbmUmZmhXR8uZXZAbrCJrZUhNi9Pyx1X52N0
         ghUVH4l5ovbj/9oXbBaYRo7phEtcC8FTCj04Fzn7IfiHYfB6T5tYG+/e12h0P/+G6B
         MbKo17ZfsjVqPDeyfD+FqWt6ycK4fecC5fGAzXcw=
Date:   Wed, 24 Jun 2020 23:00:00 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     'Kishon Vijay Abraham I' <kishon@ti.com>, robh@kernel.org,
        krzk@kernel.org, linux-samsung-soc@vger.kernel.org,
        avri.altman@wdc.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cang@codeaurora.org, devicetree@vger.kernel.org,
        kwmad.kim@samsung.com, linux-kernel@vger.kernel.org,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Message-ID: <20200624173000.GJ2324254@vkoul-mobl>
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
 <20200528011658.71590-1-alim.akhtar@samsung.com>
 <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
 <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
 <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
 <000001d646a6$6cb5fd70$4621f850$@samsung.com>
 <20200624102112.GX2324254@vkoul-mobl>
 <004b01d64a48$8bb87270$a3295750$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004b01d64a48$8bb87270$a3295750$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alim,

On 24-06-20, 22:27, Alim Akhtar wrote:
> > > > Sure, will re-send this series.
> > 
> > But patches have not been sent right, pls send and me/Kishon will review
> > 
> Thanks for your kind attention on this series. As per [0] comment from
> Kishon, patch 7/10 [1] and probably 6/10 [2] should have been Applied after
> 5.8-rc1 was tagged.

And that is something I am trying atm, but I dont have patches in my
mailbox, so would you be kind enough to resend me these patches after
rebasing to phy-next, also do add acks/reviews collected in previous
posts.

I dont think I have seen resend, or maybe I wasnt cced

> I have already send and re-send V10 of this series. Kishon has already
> reviewed and provided comments and I have addressed them as well. These
> patches already have and Reviewed-by, Tested-by tags.
> Let me know if something more needs to be done from my side.
> [0] https://lkml.org/lkml/2020/6/7/410
> [1] https://lkml.org/lkml/2020/5/27/1705
> [2] https://lkml.org/lkml/2020/5/27/1701

-- 
~Vinod

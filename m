Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826F9C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59E5320897
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgICI0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:26:14 -0400
Received: from verein.lst.de ([213.95.11.211]:36890 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgICI0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Sep 2020 04:26:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 727D868BEB; Thu,  3 Sep 2020 10:26:09 +0200 (CEST)
Date:   Thu, 3 Sep 2020 10:26:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 2/9] block: add a bdev_is_partition helper
Message-ID: <20200903082609.GA23498@lst.de>
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-3-hch@lst.de> <CAPDyKFrkcpziGFPmSd8Kx4bzhoN6zxF1E8MagLQSa4sBmnicOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFrkcpziGFPmSd8Kx4bzhoN6zxF1E8MagLQSa4sBmnicOg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 03, 2020 at 10:19:34AM +0200, Ulf Hansson wrote:
> On Thu, 3 Sep 2020 at 07:42, Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a littler helper to make the somewhat arcane bd_contains checks a
> > little more obvious.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Not sure why we have both "bd_contains" and "bd_partno", nevertheless,
> feel free to add:

Right now both are needed for how blkdev_get/put work.  But I plan to
eventual kill off bd_contains after some major surgery to that code.


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271A9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D2C60ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 07:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhJZHUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 03:20:23 -0400
Received: from verein.lst.de ([213.95.11.211]:60712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhJZHUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 03:20:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8CC436732D; Tue, 26 Oct 2021 09:17:54 +0200 (CEST)
Date:   Tue, 26 Oct 2021 09:17:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: revert HPB support
Message-ID: <20211026071754.GA31930@lst.de>
References: <20211022062011.1262184-1-hch@lst.de> <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org> <YXb2uO55W33/6ZFq@kroah.com> <yq1pmrs2zln.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1pmrs2zln.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 26, 2021 at 12:13:46AM -0400, Martin K. Petersen wrote:
> 
> Greg,
> 
> > Under this line of reasoning, why would upstream take the code at all?
> >
> > {sigh}
> 
> Sigh indeed.
> 
> > Is there a link to where the HPB developer said they would look into
> > this?  Perhaps until that happens this should be marked as BROKEN?
> 
> I say we just mark it broken for now.

I've sent a patch.

From: adam radford <aradford@gmail.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Thu, 21 Aug 2014 12:33:17 -0700
Message-ID: <CAHtARFHy8cG5bSxjodMMJy_mFnBFOxahn4MhF3-pMkGHLPDM0g@mail.gmail.com>
References: <20140708134003.GA7790@infradead.org>
	<20140801122042.GA10771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:52388 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHUTdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 15:33:18 -0400
Received: by mail-yh0-f51.google.com with SMTP id f73so8501979yha.10
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 12:33:17 -0700 (PDT)
In-Reply-To: <20140801122042.GA10771@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Aug 1, 2014 at 5:20 AM, Christoph Hellwig <hch@infradead.org> wrote:
> I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> branches.  I think we're in a good shape for the merge window, but
> I'd still like to get reviewers attention for a few driver updates that
> I'd love to get in still:
>
>  - my eata patch to remove the driver_lock
>  - the partially reviewed megaraid series

Christoph,

Can we get someone to finish reviewing the megaraid_sas patch series ?
 Or let me know if anything else needs to be corrected ?

I know it has been reviewed by yourself and Martin Petersen so far,
however, I could not find the patch series in:

http://git.infradead.org/users/hch/scsi-queue.git/shortlog/refs/heads/drivers-for-3.18

-Adam

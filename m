From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Mon, 9 Jul 2007 15:24:42 +0200
Message-ID: <20070709132441.GA5916@kernel.dk>
References: <20070608152049.GT7341@kernel.dk> <20070620223131L.fujita.tomonori@lab.ntt.co.jp> <20070709122643.GT5267@kernel.dk> <20070708153520O.fujita.tomonori@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:27051 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbXGINYe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2007 09:24:34 -0400
Content-Disposition: inline
In-Reply-To: <20070708153520O.fujita.tomonori@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

On Mon, Jul 09 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
> Date: Mon, 9 Jul 2007 14:26:44 +0200
> 
> > On Wed, Jun 20 2007, FUJITA Tomonori wrote:
> > > From: Jens Axboe <jens.axboe@oracle.com>
> > > Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
> > > Date: Fri, 8 Jun 2007 17:20:49 +0200
> > > 
> > > > On Sat, Jun 09 2007, FUJITA Tomonori wrote:
> > > > > I'll submit the bsg bidi patches shortly.
> > > > 
> > > > Great - I see them, will review and integrate next week.
> > > 
> > > Any progress on this?
> > 
> > Please resend the bsg bidi patches so I can integrate them, thanks.
> 
> Great!
> 
> I've just sent the patchset against the latest your bsg branch.

Thanks!

> BTW, seems that you forget to add my sign-off in the last two patches
> in the bsg branch.

Oh, my mistake, will add them. I just rebased it to 2.6.22 this morning.

-- 
Jens Axboe


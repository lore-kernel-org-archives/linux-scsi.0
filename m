From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 18 Sep 2007 12:18:40 +0200
Message-ID: <20070918101840.GN25592@kernel.dk>
References: <20070914211635.4774c971.pj@sgi.com> <20070914104157D.tomof@acm.org> <20070917132819.GC25592@kernel.dk> <20070917192528E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:19905 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbXIRKSR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2007 06:18:17 -0400
Content-Disposition: inline
In-Reply-To: <20070917192528E.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: pj@sgi.com, apw@shadowen.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Sep 17 2007, FUJITA Tomonori wrote:
> On Mon, 17 Sep 2007 15:28:19 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Sat, Sep 15 2007, FUJITA Tomonori wrote:
> > > On Fri, 14 Sep 2007 21:16:35 -0700
> > > Paul Jackson <pj@sgi.com> wrote:
> > > 
> > > > FUJITA Tomonori wrote:
> > > > > Can you try this patch (against 2.6.23-rc4-mm1)?
> > > > > 
> > > > > >From 592bd2049cb3e6e1f1dde7cf631879f26ddffeaa Mon Sep 17 00:00:00 2001
> > > > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > Date: Mon, 10 Sep 2007 04:17:13 +0100
> > > > > Subject: [PATCH] qla1280: sg chaining fixes
> > > > > 
> > > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > ---
> > > > >  drivers/scsi/qla1280.c |    5 ++++-
> > > > >  1 files changed, 4 insertions(+), 1 deletions(-)
> > > > 
> > > > This patch works for me.
> > > > 
> > > > I was getting the scsi errors reported earlier in
> > > > this thread, running 2.6.23-rc4-mm1 on one of our
> > > > big SGI Altix systems.
> > > > 
> > > > Applying this patch fixed it, so far as I can tell,
> > > > which is to say my system boots cleanly once again.
> > > 
> > > Thanks for testing!
> > > 
> > > Jens, we could enable use_sg_chaining option for qla1280.
> > 
> > Added, thanks!
> 
> Thanks.
> 
> BTW, please don't forget to integrate the following patches:
> 
> 
> - revert sg segment size ifdefs
> 
> http://marc.info/?l=linux-scsi&m=118881264013097&w=2
> 
> - remove sglist_len
> 
> http://marc.info/?l=linux-scsi&m=118907920405100&w=2

Added, and I rebased the sglist-* branches to current again. So
everything should be fully uptodate once more.

-- 
Jens Axboe


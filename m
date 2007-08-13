From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 13 Aug 2007 14:42:26 +0200
Message-ID: <20070813124225.GT23758@kernel.dk>
References: <1186248703.3439.20.camel@localhost.localdomain> <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain> <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain> <20070807105144.0ba67d81.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:1453 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972272AbXHMMma (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 08:42:30 -0400
Content-Disposition: inline
In-Reply-To: <20070807105144.0ba67d81.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Aug 07 2007, Andrew Morton wrote:
> On Tue, 07 Aug 2007 10:38:44 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Tue, 2007-08-07 at 11:11 -0400, Jeff Garzik wrote:
> > > James Bottomley wrote:
> > > > The initial bsg submit went via the block git tree ... which I believe
> > > > you have in -mm.  We only started taking the updates via the scsi tree
> > > 
> > > Seven hours before you posted this, in 
> > > <20070807001429.f8cb3b22.akpm@linux-foundation.org>, Andrew already 
> > > noted it was not in -mm.
> > > 
> > > A trivial examination of the broken-out mm patches backs up the absence 
> > >   of Jens' block tree, too.
> > > 
> > > So let's put this myth / bad assumption to rest, shall we?
> > 
> > Sorry ... I just assumed from the fact that it had been in the block git
> > tree for six months that it was also in -mm.
> 
> bsg was never in the #for-akpm branch of git-block.  So I assume that
> Jens had it in some other branch and for some reason never pulled it
> across into #for-akpm.

#for-akpm is usually only in very few -mm release anyway, so it's not
like it would have made much difference. We/you/I need to improve that,
certainly.

Honestly, for bsg, it wasn't much of an issue. We had build problems
when bsg was merged which was unfortunate but got fixed quickly. Having
bsg in -mm would not have caused any testing of the driver in question
outside of what it already received, given the nature of it.

-- 
Jens Axboe


From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 13 Aug 2007 20:07:57 +0200
Message-ID: <20070813180757.GZ23758@kernel.dk>
References: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain> <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain> <20070807105144.0ba67d81.akpm@linux-foundation.org> <20070813124225.GT23758@kernel.dk> <46C07FAE.1040504@garzik.org> <20070813180212.GY23758@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:13148 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S974402AbXHMSID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 14:08:03 -0400
Content-Disposition: inline
In-Reply-To: <20070813180212.GY23758@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Aug 13 2007, Jens Axboe wrote:
> On Mon, Aug 13 2007, Jeff Garzik wrote:
> > Jens Axboe wrote:
> > >#for-akpm is usually only in very few -mm release anyway, so it's not
> > >like it would have made much difference. We/you/I need to improve that,
> > >certainly.
> > >
> > >Honestly, for bsg, it wasn't much of an issue. We had build problems
> > >when bsg was merged which was unfortunate but got fixed quickly. Having
> > >bsg in -mm would not have caused any testing of the driver in question
> > >outside of what it already received, given the nature of it.
> > 
> > 
> > That's just an excuse for what happened -- you made an end run around 
> > our test tree.  Pretty please with sugar on it -- make sure changes show 
> > up in -mm.
> 
> It's not just an excuse, there are repeatably problems with getting the
> block stuff pulled into -mm. Sometimes it's my problem, but not always.
> Then I get a note saying that pulling was disabled due to merge
> problems, usually right before -mmX goes out. So it misses that release.

This may sound like I'm blaming Andrew, but that is not my intention. He
does a lot of work and he can't (and should not) attempt to fix every
integration and merge issue. Perhaps if I/we were more strict in pushing
every block bit through the block git tree, it wouldn't be so much of an
integration pain. Then the work would be in me to sort out, which I'm
happy to do.

Then there are things like the sg chaining bits, which touch a lot of
arch code. Those are just painful to deal with, for obvious reasons.
Right now there are not in -mm, but that's because of a bug that
prevents Andrews laptop from booting properly.

-- 
Jens Axboe


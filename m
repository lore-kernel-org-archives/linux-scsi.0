From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Mon, 13 Aug 2007 20:02:12 +0200
Message-ID: <20070813180212.GY23758@kernel.dk>
References: <1186248703.3439.20.camel@localhost.localdomain> <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org> <1186458941.6637.44.camel@localhost.localdomain> <20070807001429.f8cb3b22.akpm@linux-foundation.org> <1186496712.3414.17.camel@localhost.localdomain> <46B88B91.4050703@garzik.org> <1186501124.3414.32.camel@localhost.localdomain> <20070807105144.0ba67d81.akpm@linux-foundation.org> <20070813124225.GT23758@kernel.dk> <46C07FAE.1040504@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:19602 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940388AbXHMSCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 14:02:21 -0400
Content-Disposition: inline
In-Reply-To: <46C07FAE.1040504@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Aug 13 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
> >#for-akpm is usually only in very few -mm release anyway, so it's not
> >like it would have made much difference. We/you/I need to improve that,
> >certainly.
> >
> >Honestly, for bsg, it wasn't much of an issue. We had build problems
> >when bsg was merged which was unfortunate but got fixed quickly. Having
> >bsg in -mm would not have caused any testing of the driver in question
> >outside of what it already received, given the nature of it.
> 
> 
> That's just an excuse for what happened -- you made an end run around 
> our test tree.  Pretty please with sugar on it -- make sure changes show 
> up in -mm.

It's not just an excuse, there are repeatably problems with getting the
block stuff pulled into -mm. Sometimes it's my problem, but not always.
Then I get a note saying that pulling was disabled due to merge
problems, usually right before -mmX goes out. So it misses that release.

With bsg it wasn't a huge issue imho, since it was in fairly good shape
and it the issue were mainly with integration. I do try to make sure
stuff gets tested, but I also know which stuff is more important to get
exposure and multi-user testing on. bsg wasn't one of those, it's just a
lowly driver.

-- 
Jens Axboe


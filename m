From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Thu, 08 Oct 2009 19:48:18 +0000
Message-ID: <1255031298.4187.260.camel@mulgrave.site>
References: <1254844007.4383.85.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	 <1254862442.4383.183.camel@mulgrave.site>
	 <1255012399.4187.24.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbZJHTtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Oct 2009 15:49:04 -0400
In-Reply-To: <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 2009-10-08 at 07:54 -0700, Linus Torvalds wrote:
> 
> On Thu, 8 Oct 2009, Linus Torvalds wrote:
> > 
> > I'm taking it (and the parisc one I was also unhappy with)
> 
> Actually, looking at it again, I'm wavering.
> 
> That BFA driver isn't a "driver". It's a huge subsystem of it's own. It's 
> almost 50 _thousand_ lines of code for just a single "driver", and for 
> rare hardware at that.

It's a huge glue layer driver, like the aic7xxx, yes.

So the tradeoff here is that I estimate it would take years to get it to
where a linux driver should be.

Could I remind you that at the last kernel summit I was the one
advocating for holding drivers out of tree until they met our standards
and you were the one who told me not to do this ... Jon even captured
it:

https://lwn.net/Articles/298570/

I'll certainly offer this driver to Greg's drivers project to see if
they can unglue it ... I just think it's going to take a while.

> Quite frankly, the "bang per line" is almost zero. 
> 
> What the ^&@* is wrong with "enterprise SCSI" people? The amount of crazy 
> is overwhelming.
> 
> So I've pulled it, but I'm still considering just unpulling it. That 
> driver is _not_ "just a driver".  It's something more. Something dank and 
> smelly, that has grown in dark and forbidding places.
> 
> The whole crazy "high end SCSI" industry needs a f*cking exorcism.
> 
> Even if I don't unpull, I don't _ever_ want to see a driver like this 
> outside the merge window. And dammit, James, you should have realized 
> that.

Well certainly in an ideal world ... and in fact the world before KS2008
I wouldn't have accepted it until it was well cleaned up.

James



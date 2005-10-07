From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Fri, 7 Oct 2005 10:27:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
References: <200510051314.33411.ak@suse.de> <20051005113108.GA19437@parisc-linux.org>
 <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com>
 <1128519034.5063.10.camel@laptop-lcs.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:52889 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S1751096AbVJGI1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 04:27:46 -0400
In-Reply-To: <1128519034.5063.10.camel@laptop-lcs.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>

On Wed, 5 Oct 2005, Kars de Jong wrote:
> On wo, 2005-10-05 at 13:32 +0100, Richard Hirst wrote:
> > On Wed, Oct 05, 2005 at 12:39:25PM +0100, Christoph Hellwig wrote:
> > > On Wed, Oct 05, 2005 at 05:31:08AM -0600, Matthew Wilcox wrote:
> > > > On Wed, Oct 05, 2005 at 01:14:32PM +0200, Andi Kleen wrote:
> > > > > SCSI_AMIGA7XX - no maintainer, broken forever
> > > > > MVME16x_SCSI - no maintainer, broken forever
> > > > > BVME6000_SCSI - same
> > > > 
> > > > I don't think there's any point in deleting these.  I'm not even sure
> > > > why they're marked BROKEN.  They share 99% of their code with drivers
> > > > which are working.  And I thought Richard Hirst was maintaining them ...
> > > 
> > > They don't.  All these use the broken and obsolete 53c7xx driver, not
> > > James new 53c700 core.  The driver should be easy to reimplement based
> > > on the 53x700 for someone who has the hardware and cares about it.
> > 
> > I never claimed to maintain the amiga stuff, but you are right that they
> > all use the 53c7xx driver that I originally created.  The sensible thing
> > to do is to migrate those systems to use James 53c700 core, but it seems
> > wise to poll the linux-m68k list before removing them.  I don't do much
> > with my VME hardware these days but I know there have been patches
> > posted for the serial driver recently so maybe someone has the scsi
> > working.
> 
> I have at least the 53c7xx driver and the MVME16X driver working, the
> Amiga and BVME stuff is untested (but does compile).
> 
> I patched the 53c7xx core to get it to work again, but the patch is ugly
> and uses some mid level SCSI driver internals, which it shouldn't. It's
> currently only present in the m68k CVS repository.

Indeed:

http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-2.6.x-merging/POSTPONED/520-53c7xx.diff

It was rejected upstream because patches for the 53c7xx driver are no longer
accepted. we should use the 53c700 core instead.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

From: Richard Hirst <rhirst@levanta.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 15:00:05 +0100
Message-ID: <20051005140005.GD6490@levanta.com>
References: <200510051314.33411.ak@suse.de> <20051005113108.GA19437@parisc-linux.org> <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sleepie-adsl.demon.co.uk ([83.104.228.241]:59569 "EHLO
	sleepie.demon.co.uk") by vger.kernel.org with ESMTP id S932631AbVJEOAK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 10:00:10 -0400
Content-Disposition: inline
In-Reply-To: <1128519034.5063.10.camel@laptop-lcs.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>

On Wed, Oct 05, 2005 at 03:30:33PM +0200, Kars de Jong wrote:
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

Great :-)

> I patched the 53c7xx core to get it to work again, but the patch is ugly
> and uses some mid level SCSI driver internals, which it shouldn't. It's
> currently only present in the m68k CVS repository.
> 
> Are you sure it's that easy to use the new 53c700 core? These boards all
> have 53c710 chips, and are quite some changes in the 53c7xx driver
> compared to the 53c8xx driver it originated from.

The 53c700 core code handles 53c710 as well, so it should be easy.  Not
that I've actually tried..

Richard


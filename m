From: Richard Hirst <rhirst@levanta.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Sun, 9 Jul 2006 12:16:48 +0100
Message-ID: <20060709111648.GR15414@levanta.com>
References: <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <20060707124444.GA11199@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sleepie-adsl.demon.co.uk ([83.104.228.241]:56022 "EHLO
	sleepie.demon.co.uk") by vger.kernel.org with ESMTP
	id S1030199AbWGILQy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 07:16:54 -0400
Content-Disposition: inline
In-Reply-To: <20060707124444.GA11199@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Juergensmann <ij@2005.bluespice.org>, Kars de Jong <jongk@linux-m68k.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Fri, Jul 07, 2006 at 01:44:44PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 15, 2005 at 11:32:25AM +0000, Richard Hirst wrote:
> > Between us it seems Kars and I have this driver working on Amiga, MVME,
> > and BVME boards.  That is everything that used the old 53c7xx driver.  I
> > don't believe there is a combined set of patches yet (at least, I havn't
> > seen the patches for Amiga).  One complication is that we're relying on
> > some m68k-specific dma support patches from Roman Zippel that are not
> > yet integrated.
> 
> After only half a year of waiting the m68k dma api bits finally made it in..
> 
> Could you please submit your patches again now that everything should be
> in place?

I'm trying to figure out where we got to with this, but my problem is I
never saw a patch from Kars that included Amiga and [BM]VME changes in
one patch, and I only generated the [BM]VME parts.  Also  Kars changed
things to work with the new "bEBus" option James added to the 53c700
driver.

Kars, do you have such a patch handy as a starting point, or even
better, do you have a current patch that can go to liunx-scsi ?

Thanks,
  Richard


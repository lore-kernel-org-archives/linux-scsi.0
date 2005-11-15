From: Richard Hirst <rhirst@levanta.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 11:32:25 +0000
Message-ID: <20051115113225.GS5252@levanta.com>
References: <20051005113108.GA19437@parisc-linux.org> <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sleepie-adsl.demon.co.uk ([83.104.228.241]:25513 "EHLO
	sleepie.demon.co.uk") by vger.kernel.org with ESMTP id S932372AbVKOLce
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 06:32:34 -0500
Content-Disposition: inline
In-Reply-To: <20051115103034.GA24352@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Juergensmann <ij@2005.bluespice.org>, Kars de Jong <jongk@linux-m68k.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, Nov 15, 2005 at 10:30:34AM +0000, Christoph Hellwig wrote:
> On Tue, Nov 15, 2005 at 11:17:09AM +0100, Ingo Juergensmann wrote:
> > > Did you make any progress on this? 
> > 
> > I guess he made... Kars gave me a kernel image for Amiga:
> > 
> > 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
> > scsi0: 53c710 rev 2
> > 53c700: dmode=80 dcntl=01 ctest7=02
> > scsi0 : WarpEngine 40xx
> > 
> > spice:/home/ij# uptime
> >  11:13:14 up 4 days, 14:59,  3 users,  load average: 0.02, 0.20, 0.13
> > 
> > So far, I haven't experienced any problems with that new driver. I intend to
> > try that kernel on an Amiga 4000T with its implementation of that chip
> > (A4091-alike)...
> 
> Very nice.  Kars, could you send your patches to linux-scsi please?

Between us it seems Kars and I have this driver working on Amiga, MVME,
and BVME boards.  That is everything that used the old 53c7xx driver.  I
don't believe there is a combined set of patches yet (at least, I havn't
seen the patches for Amiga).  One complication is that we're relying on
some m68k-specific dma support patches from Roman Zippel that are not
yet integrated.

Richard


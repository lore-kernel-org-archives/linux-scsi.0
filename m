From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Sun, 09 Jul 2006 13:25:04 +0200
Message-ID: <1152444304.5567.2.camel@kars.perseus.home>
References: <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:25787 "EHLO
	smtpq3.groni1.gr.home.nl") by vger.kernel.org with ESMTP
	id S1030454AbWGILZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 07:25:21 -0400
In-Reply-To: <20060709111648.GR15414@levanta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On zo, 2006-07-09 at 12:16 +0100, Richard Hirst wrote:
> On Fri, Jul 07, 2006 at 01:44:44PM +0100, Christoph Hellwig wrote:
> > After only half a year of waiting the m68k dma api bits finally made it in..
> > 
> > Could you please submit your patches again now that everything should be
> > in place?
> 
> I'm trying to figure out where we got to with this, but my problem is I
> never saw a patch from Kars that included Amiga and [BM]VME changes in
> one patch, and I only generated the [BM]VME parts.  Also  Kars changed
> things to work with the new "bEBus" option James added to the 53c700
> driver.
> 
> Kars, do you have such a patch handy as a starting point, or even
> better, do you have a current patch that can go to liunx-scsi ?

Yes, I have a current patch which integrates all of the above mentioned
changes. Didn't get around to testing it yet with the integrated DMA API
patches.

I hope to be able to send it later this week.


Kind regards,

Kars.



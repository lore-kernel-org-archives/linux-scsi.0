From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Mon, 30 Oct 2006 13:34:39 +0100
Message-ID: <1162211680.24098.8.camel@laptop-lcs.localdomain>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
 <20051007134232.GA6490@levanta.com>
 <1128693232.5041.7.camel@laptop-lcs.localdomain>
 <20051115095152.GA23470@infradead.org>
 <20051115101709.GK7031@2004.bluespice.org>
 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
 <1152444304.5567.2.camel@kars.perseus.home>
 <20061030111311.GA756@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:14066 "EHLO psmtp04.wxs.nl")
	by vger.kernel.org with ESMTP id S932135AbWJ3MfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 07:35:09 -0500
In-reply-to: <20061030111311.GA756@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Hirst <rhirst@levanta.com>, Ingo Juergensmann <ij@2005.bluespice.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> On Sun, Jul 09, 2006 at 01:25:04PM +0200, Kars de Jong wrote:
> > Yes, I have a current patch which integrates all of the above mentioned
> > changes. Didn't get around to testing it yet with the integrated DMA API
> > patches.
> > 
> > I hope to be able to send it later this week.
> 
> Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> mess in the upoming request_buffer transition, and unless the m68k
> folks provide the new 53c700-based driver I'll just submit a patch to
> rip 53c7xx and users out without replacement.

Unfortunately real life got in the way. I don't have much time to work
on m68k anymore.

This weekend I did a test with 2.6.18 and the new 53c700-based driver on
my MVME167 which didn't work very well. It locked up several times, and
the exception handler got stuck in some loop.

I did not have these problems with 2.6.16.

I will send the patch in its current form, so that the old 53c7xx driver
can be removed.


Kind regards,

Kars.



From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Mon, 30 Oct 2006 11:13:11 +0000
Message-ID: <20061030111311.GA756@infradead.org>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com> <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com> <1152444304.5567.2.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38305 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161254AbWJ3LNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 06:13:25 -0500
Content-Disposition: inline
In-Reply-To: <1152444304.5567.2.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Sun, Jul 09, 2006 at 01:25:04PM +0200, Kars de Jong wrote:
> Yes, I have a current patch which integrates all of the above mentioned
> changes. Didn't get around to testing it yet with the integrated DMA API
> patches.
> 
> I hope to be able to send it later this week.

Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
mess in the upoming request_buffer transition, and unless the m68k
folks provide the new 53c700-based driver I'll just submit a patch to
rip 53c7xx and users out without replacement.


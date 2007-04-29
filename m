From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Sun, 29 Apr 2007 22:43:43 +0100
Message-ID: <20070429214343.GA1774@infradead.org>
References: <20051115113225.GS5252@levanta.com> <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com> <1152444304.5567.2.camel@kars.perseus.home> <20061030111311.GA756@infradead.org> <1162331224.7805.18.camel@kars.perseus.home> <1166394517.9647.22.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.62.0612181032080.24587@pademelon.sonytel.be> <20061219030919.GG17561@ftp.linux.org.uk> <1166822512.27647.2.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161464AbXD2VoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Apr 2007 17:44:13 -0400
Content-Disposition: inline
In-Reply-To: <1166822512.27647.2.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Geert Uytterhoeven <geert@linux-m68k.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Fri, Dec 22, 2006 at 10:21:52PM +0100, Kars de Jong wrote:
> On di, 2006-12-19 at 03:09 +0000, Al Viro wrote:
> > > m68k-generic-io.diff
> > 
> > Hmm...  That breaks when you have ISA && !PCI (e.g. amiga or q40 defconfig):
> > 
> > lib/built-in.o: In function `ioread32_rep':
> > (.text+0xc31a): undefined reference to `insl'
> > lib/built-in.o: In function `iowrite32_rep':
> > (.text+0xc43e): undefined reference to `outsl'
> > lib/built-in.o: In function `ioread32':
> > (.text+0xc7da): undefined reference to `readl'
> > lib/built-in.o: In function `iowrite32':
> > (.text+0xca6a): undefined reference to `writel'
> 
> Thanks for spotting that. I'll update the patch.

Where do we stand on this?  IMHO we should just put the scsi driver
update in now so we can kill all the old cruft and let the notoriously
lagging m68k arch support catch up once they get the time for it.



From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Fri, 22 Dec 2006 22:21:52 +0100
Message-ID: <1166822512.27647.2.camel@kars.perseus.home>
References: <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
	 <1152444304.5567.2.camel@kars.perseus.home>
	 <20061030111311.GA756@infradead.org>
	 <1162331224.7805.18.camel@kars.perseus.home>
	 <1166394517.9647.22.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.62.0612181032080.24587@pademelon.sonytel.be>
	 <20061219030919.GG17561@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq3.groni1.gr.home.nl ([213.51.130.202]:54629 "EHLO
	smtpq3.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbWLVWd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2006 17:33:29 -0500
In-Reply-To: <20061219030919.GG17561@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On di, 2006-12-19 at 03:09 +0000, Al Viro wrote:
> > m68k-generic-io.diff
> 
> Hmm...  That breaks when you have ISA && !PCI (e.g. amiga or q40 defconfig):
> 
> lib/built-in.o: In function `ioread32_rep':
> (.text+0xc31a): undefined reference to `insl'
> lib/built-in.o: In function `iowrite32_rep':
> (.text+0xc43e): undefined reference to `outsl'
> lib/built-in.o: In function `ioread32':
> (.text+0xc7da): undefined reference to `readl'
> lib/built-in.o: In function `iowrite32':
> (.text+0xca6a): undefined reference to `writel'

Thanks for spotting that. I'll update the patch.

Kars.



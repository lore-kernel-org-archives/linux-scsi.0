From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Fri, 7 Jul 2006 13:44:44 +0100
Message-ID: <20060707124444.GA11199@infradead.org>
References: <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31959 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932157AbWGGMov (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jul 2006 08:44:51 -0400
Content-Disposition: inline
In-Reply-To: <20051115113225.GS5252@levanta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Kars de Jong <jongk@linux-m68k.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, Nov 15, 2005 at 11:32:25AM +0000, Richard Hirst wrote:
> Between us it seems Kars and I have this driver working on Amiga, MVME,
> and BVME boards.  That is everything that used the old 53c7xx driver.  I
> don't believe there is a combined set of patches yet (at least, I havn't
> seen the patches for Amiga).  One complication is that we're relying on
> some m68k-specific dma support patches from Roman Zippel that are not
> yet integrated.

After only half a year of waiting the m68k dma api bits finally made it in..

Could you please submit your patches again now that everything should be
in place?

From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 13:08:35 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0511151306470.1605@scrub.home>
References: <20051005113108.GA19437@parisc-linux.org> <20051005113925.GA11202@infradead.org>
 <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain>
 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com>
 <1128693232.5041.7.camel@laptop-lcs.localdomain> <20051115095152.GA23470@infradead.org>
 <20051115101709.GK7031@2004.bluespice.org> <20051115103034.GA24352@infradead.org>
 <20051115113225.GS5252@levanta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:1196 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S932385AbVKOMJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 07:09:27 -0500
In-Reply-To: <20051115113225.GS5252@levanta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Juergensmann <ij@2005.bluespice.org>, Kars de Jong <jongk@linux-m68k.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Hi,

On Tue, 15 Nov 2005, Richard Hirst wrote:

> > Very nice.  Kars, could you send your patches to linux-scsi please?
> 
> Between us it seems Kars and I have this driver working on Amiga, MVME,
> and BVME boards.  That is everything that used the old 53c7xx driver.  I
> don't believe there is a combined set of patches yet (at least, I havn't
> seen the patches for Amiga).  One complication is that we're relying on
> some m68k-specific dma support patches from Roman Zippel that are not
> yet integrated.

Where I'm waiting for upstream blockage to get resolved before I continue 
with this.

bye, Roman

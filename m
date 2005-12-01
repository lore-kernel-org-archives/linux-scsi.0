From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Thu, 01 Dec 2005 21:43:13 +0100
Message-ID: <1133469794.5759.8.camel@kars.perseus.home>
References: <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
	 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <1132056707.6134.11.camel@localhost.localdomain>
	 <20051122083631.GA21523@infradead.org>
	 <1132695837.8928.11.camel@localhost.localdomain>
	 <1133110038.3331.20.camel@mulgrave>  <1133303092.3492.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:60374 "EHLO
	smtpq3.tilbu1.nb.home.nl") by vger.kernel.org with ESMTP
	id S932456AbVLAUnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 15:43:23 -0500
In-Reply-To: <1133303092.3492.58.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On di, 2005-11-29 at 16:24 -0600, James Bottomley wrote:
> How about the attached.  I've tested it out on parisc and it works
> fine ... in fact I'm tempted to commit it simply because we now avoid
> the double swap for every I/O operation.

I've tested it on my MVME167, using the generic iomap() interface
implementation, and it seems to work fine.

I noticed one thing in the patch:

> +#ifdef CONFIG_53C700_BE_BUS)
                              ^
There's a trailing ) there.

Ingo, can you test the kernel at
http://members.home.nl/karsdejong/vmlinuz-2.6.14-amiga-4 on your
hardware? It also has NFS client and AFFS support.


Kind regards,

Kars.



From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 30 Nov 2005 09:31:23 +0100
Message-ID: <1133339483.5221.2.camel@laptop-lcs.localdomain>
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
 <1133110038.3331.20.camel@mulgrave> <1133303092.3492.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from psmtp04.wxs.nl ([195.121.247.13]:10447 "EHLO psmtp04.wxs.nl")
	by vger.kernel.org with ESMTP id S1751132AbVK3Ib2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 03:31:28 -0500
In-reply-to: <1133303092.3492.58.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Ingo Juergensmann <ij@2005.bluespice.org>, Richard Hirst <rhirst@levanta.com>

On di, 2005-11-29 at 16:24 -0600, James Bottomley wrote:
> On Sun, 2005-11-27 at 11:47 -0500, James Bottomley wrote:
> > I assume your problems is also that the 53c7x0 chip on the MAC is also
> > on a BE bus, so I think what you want is another flag:
> > 
> > 53c700_BE_BUS
> > 
> > which causes all the io macros to be ioread/write<n>be.  Which will
> > avoid the nasty double swap we do on PA.
> 
> How about the attached.  I've tested it out on parisc and it works
> fine ... in fact I'm tempted to commit it simply because we now avoid
> the double swap for every I/O operation.

Looks fine to me. I'll see if I can try it out on m68k tonight. The
driver isn't used on MACs by the way, it's used on Amigas and VME single
board computers.


Kind regards,

Kars.



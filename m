From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: RE: [PATCH] ips driver for 2.4.23-pre4
Date: Fri, 9 Jan 2004 10:35:43 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58L.0401091035320.30956@logos.cnet>
References: <A121ABA5B472B74EB59076B8E3C8F0190129F3@rtpe2k01.adaptec.com>
 <1073596589.2915.276.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intra.cyclades.com ([64.186.161.6]:46012 "EHLO
	intra.cyclades.com") by vger.kernel.org with ESMTP id S261464AbUAIMnC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 07:43:02 -0500
In-Reply-To: <1073596589.2915.276.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Hammer, Jack" <Jack_Hammer@adaptec.com>, Christoph Hellwig <hch@infradead.org>, Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>



On Thu, 8 Jan 2004, James Bottomley wrote:

> On Thu, 2004-01-08 at 15:18, Hammer, Jack wrote:
> > The reason this compiler warning exists is that these are the only hardware
> > platforms that support this adapter.  Use of this adapter is any other box
> > can cause serious problems and is not supported by anyone.  Removal of this
> > warning has no effect on the executable code and would not improve the
> > driver in my opinion.  If I was including a module in my system that is not
> > going to work, I'd like to know about it.
> [...]
> > > -#if !defined(__i386__) && !defined(__ia64__) -#error "This driver has
> > > only been tested on the x86/ia64 platforms"
> > > +#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
> > > +#error "This driver has only been tested on the x86/ia64/x86_64
> > platforms"
> > >  #endif
>
> This is actually an #error though, not a #warning...could we at least
> downgrade it to #warning (like has already been done for ips) so I don't
> get spurious compile failure reports from people doing make allyes
> configurations on non-x86 boxes?

Jack?

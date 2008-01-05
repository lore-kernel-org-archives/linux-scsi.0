From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: An MCA ESP driver
Date: Sat, 05 Jan 2008 15:18:12 -0600
Message-ID: <1199567892.3399.32.camel@localhost.localdomain>
References: <20070806232458.GC9732@parisc-linux.org>
	 <20070807.002604.78735512.davem@davemloft.net>
	 <20070815172600.GF16277@parisc-linux.org>
	 <20070815.145551.78731552.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60489 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbYAEVSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 16:18:16 -0500
In-Reply-To: <20070815.145551.78731552.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org


On Wed, 2007-08-15 at 14:55 -0700, David Miller wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> Date: Wed, 15 Aug 2007 11:26:00 -0600
> 
> > On Tue, Aug 07, 2007 at 12:26:04AM -0700, David Miller wrote:
> > > > -	struct sbus_dma		*dma;
> > > > +	union {
> > > > +		struct sbus_dma	*sbus_dma;
> > > > +		unsigned int	x86_dma;
> > > > +	};
> > > >  };
> > > 
> > > Feel free to make this a "void *dma_cookie" or similar.
> > > It's private to the bus front-end.
> > 
> > Hi Dave,
> > 
> > Could I just clarify; would you prefer it to be a void *?  I prefer the
> > anonymous union that I have there right now, but I'm not particularly
> > attached to it.  In particular, I don't really care to be casting ints
> > (x86) to pointers, but that's a matter of personal taste.
> 
> Alternatively, you could remove this member entirely, and
> make the front-end driver allocate a private area at the
> end of "struct esp" to use for whatever purpose it likes.
> 
> I'm mostly ambivalent, but if the member stays it should be
> some generic type rather than anything front-end specific
> like it is now.

Just a check up on this:  Matthew were you ever going to complete the
mca_94x conversion?  It's quite topical because it would be another
example driver for the m68k people to look at.

If not, I can probably complete the bits you haven't yet done, but it
would be nice to know.

Thanks,

James



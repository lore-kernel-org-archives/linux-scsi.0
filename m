From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 17:05:59 -0600
Message-ID: <1203548760.3109.53.camel@localhost.localdomain>
References: <1193864605.25899.253.camel@wirenth>
	 <20080220171409.GB27736@parisc-linux.org> <200802201849.48312.ak@suse.de>
	 <1203533015.3181.2.camel@wirenth> <47BC7B34.7020308@suse.de>
	 <1203542815.3181.6.camel@wirenth>
	 <20080220225527.GA26887@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49135 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYBTXGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 18:06:09 -0500
In-Reply-To: <20080220225527.GA26887@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: ian <spyro@f2s.com>, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org, Dmitry <dbaryshkov@gmail.com>

On Wed, 2008-02-20 at 22:55 +0000, Russell King wrote:
> On Wed, Feb 20, 2008 at 09:26:55PM +0000, ian wrote:
> > 
> > On Wed, 2008-02-20 at 20:10 +0100, Andi Kleen wrote:
> > > Is there a time frame on when will this happen? Will you be ready
> > > for the .26 merge window?
> > 
> > I think the big sticking point now is getting the generic clock
> > interface merged - Dmitry is working hard on that.
> 
> And that requires a review from my side, which I've not been able to do
> yet...
> 
> It seems there's a number of dependencies that the code depends on,
> and trying to push to remove an interface which is used on to-be-merged
> code which is being _actively_ worked on to bring it to merge standard
> is just stupid - that's a recipe for forcing folk into a corner where
> they'll never have everything merged that they need for their particular
> set of code.
> 
> The alternative is that the code which uses it could be merged as is,
> albiet without the dependents, so effectively it couldn't be built.
> But then it'll satisfy Andi's grep that there are users in the tree.

Don't worry.  The interface fills a need (allocation of on chip or
behind bridge memory) and we have two in tree users: NCR_Q720 and
ochi-sm501, so it's not going anywhere.

James



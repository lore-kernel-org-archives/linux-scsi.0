From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 22:55:27 +0000
Message-ID: <20080220225527.GA26887@flint.arm.linux.org.uk>
References: <1193864605.25899.253.camel@wirenth> <20080220171409.GB27736@parisc-linux.org> <200802201849.48312.ak@suse.de> <1203533015.3181.2.camel@wirenth> <47BC7B34.7020308@suse.de> <1203542815.3181.6.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58097 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYBTW6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 17:58:18 -0500
Content-Disposition: inline
In-Reply-To: <1203542815.3181.6.camel@wirenth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ian <spyro@f2s.com>
Cc: Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org, Dmitry <dbaryshkov@gmail.com>

On Wed, Feb 20, 2008 at 09:26:55PM +0000, ian wrote:
> 
> On Wed, 2008-02-20 at 20:10 +0100, Andi Kleen wrote:
> > Is there a time frame on when will this happen? Will you be ready
> > for the .26 merge window?
> 
> I think the big sticking point now is getting the generic clock
> interface merged - Dmitry is working hard on that.

And that requires a review from my side, which I've not been able to do
yet...

It seems there's a number of dependencies that the code depends on,
and trying to push to remove an interface which is used on to-be-merged
code which is being _actively_ worked on to bring it to merge standard
is just stupid - that's a recipe for forcing folk into a corner where
they'll never have everything merged that they need for their particular
set of code.

The alternative is that the code which uses it could be merged as is,
albiet without the dependents, so effectively it couldn't be built.
But then it'll satisfy Andi's grep that there are users in the tree.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

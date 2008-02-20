From: ian <spyro@f2s.com>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 21:26:55 +0000
Message-ID: <1203542815.3181.6.camel@wirenth>
References: <1193864605.25899.253.camel@wirenth>
	 <20080220171409.GB27736@parisc-linux.org>  <200802201849.48312.ak@suse.de>
	 <1203533015.3181.2.camel@wirenth>  <47BC7B34.7020308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:30605
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436AbYBTV1B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 16:27:01 -0500
In-Reply-To: <47BC7B34.7020308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org, Dmitry <dbaryshkov@gmail.com>


On Wed, 2008-02-20 at 20:10 +0100, Andi Kleen wrote:
> ian wrote:
> > On Wed, 2008-02-20 at 18:49 +0100, Andi Kleen wrote:
> >>> So ... it's been 4 months.  Any new users merged?
> >> At least dmam_declare_coherent_memory is completely unused as of
> >> 2.6.25-rc* I plan to remove these.
> > 
> > Please do not.
> 
> Do you use dma_declare_* or dmam_declare_*. The first is used
> currently. Only the second is unused.

Ah, sorry, I missed the extra 'm' as I scanned the mail.

We are using the former.

> > Dmitry and I are still working on getting the users of this into the
> > kernel.
> 
> Is there a time frame on when will this happen? Will you be ready
> for the .26 merge window?

I think the big sticking point now is getting the generic clock
interface merged - Dmitry is working hard on that.

The rest of the code is pretty clean now.

> Well if it takes longer the best strategy might be to remove
> unused stuff now and you just readd what you need when you
> really need it in tree.

I think that would not be the best path now.

btw, kernel-discuss@handhelds.org appears to be a dead list these days.


From: Andi Kleen <ak@suse.de>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 20:10:44 +0100
Message-ID: <47BC7B34.7020308@suse.de>
References: <1193864605.25899.253.camel@wirenth>	 <20080220171409.GB27736@parisc-linux.org>  <200802201849.48312.ak@suse.de> <1203533015.3181.2.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:57502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYBTTJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 14:09:13 -0500
In-Reply-To: <1203533015.3181.2.camel@wirenth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ian <spyro@f2s.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

ian wrote:
> On Wed, 2008-02-20 at 18:49 +0100, Andi Kleen wrote:
>>> So ... it's been 4 months.  Any new users merged?
>> At least dmam_declare_coherent_memory is completely unused as of
>> 2.6.25-rc* I plan to remove these.
> 
> Please do not.

Do you use dma_declare_* or dmam_declare_*. The first is used
currently. Only the second is unused.

> 
> Dmitry and I are still working on getting the users of this into the
> kernel.

Is there a time frame on when will this happen? Will you be ready
for the .26 merge window?

> 
> the chips are multifunction devices, and their drivers are depending on
> a lot of incompletely merged code and APIs.

Well if it takes longer the best strategy might be to remove
unused stuff now and you just readd what you need when you
really need it in tree.

-Andi

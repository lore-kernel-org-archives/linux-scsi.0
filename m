From: Andi Kleen <ak@suse.de>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 18:49:48 +0100
Message-ID: <200802201849.48312.ak@suse.de>
References: <1193864605.25899.253.camel@wirenth> <20080220171409.GB27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:45999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYBTRtw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 12:49:52 -0500
In-Reply-To: <20080220171409.GB27736@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: ian <spyro@f2s.com>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Wednesday 20 February 2008 18:14:09 Matthew Wilcox wrote:
> On Wed, Oct 31, 2007 at 09:03:24PM +0000, ian wrote:
> > I'd like to ask that this not happen - there are several users of this
> > code in the handhelds.org tree, which we hope will merge into mainline.
> > this code is _essential_ to allow support of these devices.
> 
> So ... it's been 4 months.  Any new users merged?

At least dmam_declare_coherent_memory is completely unused as of 2.6.25-rc*
I plan to remove these.

-Andi
> 



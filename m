From: ian <spyro@f2s.com>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 18:43:35 +0000
Message-ID: <1203533015.3181.2.camel@wirenth>
References: <1193864605.25899.253.camel@wirenth>
	 <20080220171409.GB27736@parisc-linux.org>  <200802201849.48312.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:8853
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbYBTSxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 13:53:43 -0500
In-Reply-To: <200802201849.48312.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org


On Wed, 2008-02-20 at 18:49 +0100, Andi Kleen wrote:
> > 
> > So ... it's been 4 months.  Any new users merged?
> 
> At least dmam_declare_coherent_memory is completely unused as of
> 2.6.25-rc* I plan to remove these.

Please do not.

Dmitry and I are still working on getting the users of this into the
kernel.

the chips are multifunction devices, and their drivers are depending on
a lot of incompletely merged code and APIs.

The drivers _are_ working and _are_ in use in a half dozen devices.

I know the delays are a pain but theres a lot of work going on in the
backround on these. The code has not been forgotten.


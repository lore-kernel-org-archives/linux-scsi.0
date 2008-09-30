From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mac scsi, ncr5380
Date: Tue, 30 Sep 2008 04:45:37 -0400
Message-ID: <20080930084536.GA28524@infradead.org>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au> <48DF8398.30000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51018 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYI3Ipp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 04:45:45 -0400
Content-Disposition: inline
In-Reply-To: <48DF8398.30000@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, Christoph Hellwig <hch@infradead.org>

On Sun, Sep 28, 2008 at 04:16:08PM +0300, Boaz Harrosh wrote:
> >From a SCSI generic point of view. The current xxx_NCR5380 remind me allot
> of the old ESP drivers stack. At-least at the surface level of the patches
> I sent for both these drivers. I was lucky, at the end, to only send the
> xxx_NCR5380 patches, because, as strongly recommended by Christoph Hellwig
> (CCed), the old ESP stack was brilliantly replaced by a new one. That is 1/10
> the size of the old one, and currently supports most of the interesting devices
> out there. My unsent patches was a catalyst, for the now broken old-driver-stack,
> to be removed quickly. And it seems every one is happy.
> 
> My point being, If you are looking to do a major cleanup work, on all these
> 1/2 forks. Maybe give a hard thought on just trashing the all thing and crafting
> a completely new stack, 1/10 the size and much simpler, modern, and maintainable.

That would we very nice.  All 5380 drivers are in a really sorry state,
and a new one even if only working for sun3 and atari for now would be a
great change.  I'm not even sure if we have any users left for the PC
and arm 5380 drivers.


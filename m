From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] some tmscsim consolidation
Date: Sun, 6 Jun 2004 22:33:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606203314.GA4410@lst.de>
References: <20040606124156.GA30931@lst.de> <Pine.LNX.4.44.0406062148580.10742-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:12753 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263614AbUFFUdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 16:33:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0406062148580.10742-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 06, 2004 at 10:22:41PM +0200, Guennadi Liakhovetski wrote:
> On Sun, 6 Jun 2004, Christoph Hellwig wrote:
> 
> > I've looked through my old tmscsim patch queue and found this one:
> >
> >  - merge dc390_initDCB into dc390_slave_alloc
> >  - merge DC390_release and dc390_shutdown into dc390_remove_one,
> >    use del_timer_sync to make sure the timer is really deleted on
> >    removal, adjust locking accordingly
> >  - some tiny related cleanups
> 
> Thanks for the patch, Christoph. As you might have seen, I've already
> submitted a patch, which merges _some_ of the functions above, following
> your request:-). Is your patch based on something like vanilla 2.6.6, or
> some bkX / preY? I'll try to find a version, to which it cleanly applies
> and then re-diff with the current state.

Ah sorry.  It's against James' scsi-misc-2.6 tree from a day or two ago.
I'll keep my eyes open and when I see your patch going in somewhere I'll
resend what's left if anything.

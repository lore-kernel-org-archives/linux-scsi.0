From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] some tmscsim consolidation
Date: Mon, 7 Jun 2004 22:37:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406072221140.4028-100000@poirot.grange>
References: <20040606203314.GA4410@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:43737 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265039AbUFGUiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 16:38:10 -0400
In-Reply-To: <20040606203314.GA4410@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 6 Jun 2004, Christoph Hellwig wrote:

> On Sun, Jun 06, 2004 at 10:22:41PM +0200, Guennadi Liakhovetski wrote:
> > On Sun, 6 Jun 2004, Christoph Hellwig wrote:
> >
> > > I've looked through my old tmscsim patch queue and found this one:
> > >
> > >  - merge dc390_initDCB into dc390_slave_alloc
> > >  - merge DC390_release and dc390_shutdown into dc390_remove_one,
> > >    use del_timer_sync to make sure the timer is really deleted on
> > >    removal, adjust locking accordingly
> > >  - some tiny related cleanups
> >
> > Thanks for the patch, Christoph. As you might have seen, I've already
> > submitted a patch, which merges _some_ of the functions above, following
>
> Ah sorry.  It's against James' scsi-misc-2.6 tree from a day or two ago.
> I'll keep my eyes open and when I see your patch going in somewhere I'll
> resend what's left if anything.

Thanks again! That would, certainly, be a lot easier for me. But don't
worry - there'll be enough left for you:-) I think, the only thing I've
done from the above, is merging dc390_initDCB into dc390_slave_alloc and
DC390_release into dc390_remove_one, following your suggestion of 23 May.

Thanks
Guennadi
---
Guennadi Liakhovetski




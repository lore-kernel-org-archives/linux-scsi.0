From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: Ultra160 controller on 32bit pci
Date: Thu, 06 May 2004 17:51:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409A5F05.A7FA9935@danbbs.dk>
References: <4099F408.E424C26A@danbbs.dk> <20040506152923.GB2281@parcelfarce.linux.theplanet.co.uk>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:7519 "EHLO
	pfepb.post.tele.dk") by vger.kernel.org with ESMTP id S262768AbUEFPtQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 11:49:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Linux-scsi <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> 
> On Thu, May 06, 2004 at 10:15:04AM +0200, Mogens Valentin wrote:
> > Currently using Adaptec 29160, works fine, but it's only 160/2, after
> > all.
> > I'm curious if other controllers can provide better performance when
> > used on a 32bit pci bus?
> 
> Theoretical bandwidth on a 33MHz 32-bit PCI bus is around 132MB/s.
> In practice you never attain that because of overhead in turning the bus
> around and typical figures quoted in the PCI spec are between 60-107MB/s.
> So you already saturated the PCI bus (never mind what else you have on
> that bus).

I'm aware of that. I have a 40MHz pci bus, no problems with any devices
(most modern cards are build for 66MHz anyway), so I'm interested in
scsi controllers possible utilising a 32bit interface better (than the
29160).
Haven't seen any though, thus the question.

> > In a few month I might switch to a pci-express/opteron setup, so I'd
> > like some indication about controllers for that bus.
> 
> Depends what people are going to ship.  I've heard rumours the initial
> chipsets will have an x16 link for graphics and an x4 link for other I/O.

Yes, a few such boards already exist. No matter which combinations will
be on boards, I'll be happy with on x16 slot for video and one
x-whatever for a scsi controller.

Thanks for replying..

-- 
Kind regards,
Mogens Valentin
Networking, Security
www.danbbs.dk/~monz
Phone +45 32 525 878

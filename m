From: Jens Axboe <axboe@suse.de>
Subject: Re: [usb-storage] 2.4.27rc2, DVD-RW support broke DVD-RAM writes
Date: Mon, 2 Aug 2004 10:07:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040802080704.GH10496@suse.de>
References: <20040730153657.GB2748@logos.cnet> <20040731163334.GH23697@suse.de> <76A380F2-E3C5-11D8-B01E-00039398BB5E@ieee.org> <06E9D950-E3EF-11D8-B976-00039398BB5E@ieee.org> <70B2077E-E401-11D8-B976-00039398BB5E@ieee.org> <20040801235357.GB18403@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:34506 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266357AbUHBH7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2004 03:59:36 -0400
Content-Disposition: inline
In-Reply-To: <20040801235357.GB18403@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org, "usb-storage@lists.one-eyed-alien.net list" <usb-storage@lists.one-eyed-alien.net>

On Sun, Aug 01 2004, Matthew Dharm wrote:
> On Sun, Aug 01, 2004 at 03:26:24PM -0600, Pat LaVarre wrote:
> > Jens A/ Matt D:
> > 
> > Linux 2.4.27-rc4 and 2.4.26 do Not recognise USB DVD-RAM disc 
> > rewritability, even though 2.4.27 has recognised USB Iomega REV disc 
> > rewritability at least since -rc3.
> > 
> > Q0: Agreed?
> 
> I'll take your word for it.
> 
> > Q1: Would you consider a promptly written patch to persuade 2.4.27-rc4 
> > to recognise USB DVD-RAM rewritability?  Or is 2.4 development already 
> > too over?
> 
> I've turned over 2.4 maintance to Pete Zaitcev.

I think this was a general question. If the patch is to go into
2.4.27-rc now, then it has to be to the point and straight forward (aka
obviously correct). Otherwise we back it out, and get it fixed for
2.4.28-rc.

> > Q2: Where do you want the patch?  In drivers/usb?  In drivers/scsi?
> 
> To me, it sounds like drivers/scsi would be better.  Tho I can see good
> arguments for either location.

Agree

> > Q3: What patch do you want? Should we try op x5A after op x1A fails?  
> > Or should we try only op x5A?  Or should we try op x5A first?
> 
> I would think on a SCSI Level 2 device, we should start with x5A.

Agree. But such a change alone means that it cannot go into 2.4.27, it
has to be in 2.4.28-pre.

-- 
Jens Axboe


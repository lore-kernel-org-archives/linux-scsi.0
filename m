From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC7xxx on 2.6.18
Date: Tue, 30 Jan 2007 20:30:31 -0500
Message-ID: <20070131013031.GA14422@animx.eu.org>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org> <20070130121820.GA11843@animx.eu.org> <20070130095746.8c2e7db9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:44667 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbXAaBaZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 20:30:25 -0500
Content-Disposition: inline
In-Reply-To: <20070130095746.8c2e7db9.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

NOTE: I am not on the linux-scsi list, keep me in CC.

Andrew Morton wrote:
> On Tue, 30 Jan 2007 07:18:20 -0500
> Wakko Warner <wakko@animx.eu.org> wrote:
> > Andrew Morton wrote:
> > > Yes, getting the oops traces will help, thanks.  And confirmation on a more
> > > recent kernel would be good.
> > 
> > I tested with a 2.6.20-rc6 kernel and the MAC 39160 card.  There was no oops
> > and I was able to access the 2 disks.  This was on a different PC though. 
> > I'll try it again on the original PC.
> 
> Thanks.

The PC was a completely different PC when I tried it that time.  This time,
I tried it on a similar PC (same motherboard model, but not the exact same
machine).  I had no problems with 2.6.18.  I looked a little close and I
noticed that the original machine was actually overclocked.  I did the same
to the machine that works and it is now not working.  So the problem with
the mac card seems to be the overclocking.  I completely forgotten about it
since it was a test machine anyway.

So this just leaves the problem I've experienced on the machine with the PC
u160 and the u/uw dual card.

> > Should I try 2.6.19 as well?
> 
> There's not a lot of point in doing so.  If/when we come up with a
> 2.6.20-rc6 fix we'll know whether it is applicable to 2.6.19.x.

I'll try 2.6.19 on the machine with the 2 scsi cards with the option roms
disabled.  I'd rather not run a -rc kernel on this machine.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???

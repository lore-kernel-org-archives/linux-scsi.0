From: Greg KH <greg@kroah.com>
Subject: Re: What still uses the block layer?
Date: Sun, 14 Oct 2007 23:00:15 -0700
Message-ID: <20071015060015.GB32268@kroah.com>
References: <200710112011.22000.rob@landley.net> <20071013220539.GD29934@parisc-linux.org> <1192400672.3351.56.camel@localhost.localdomain> <200710141845.44750.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbXJOGGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 02:06:01 -0400
Content-Disposition: inline
In-Reply-To: <200710141845.44750.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sun, Oct 14, 2007 at 06:45:44PM -0500, Rob Landley wrote:
> On Sunday 14 October 2007 5:24:32 pm James Bottomley wrote:
> > On Sat, 2007-10-13 at 16:05 -0600, Matthew Wilcox wrote:
> > > On Thu, Oct 11, 2007 at 08:11:21PM -0500, Rob Landley wrote:
> > > > My impression from asking questions on the linux-scsi mailing list is
> > > > that the scsi upper/middle/lower layers doesn't use the block layer
> > > > described in Documentation/block/*.
> > >
> > > Entirely incorrect.
> >
> > OK, right ... could we please get a sense of decorum back on this list.
> 
> Did I reply to the insult?
> 
> > Rob, if you didn't ask your alleged questions in such a pejorative
> > manner, we'd get a lot further
> 
> I'm not attempting to be pejorative.
> 
> I admit a certain amount of personal annoyance that once the SCSI layer 
> consumes a category of device (USB, SATA, PATA), they can often _only_ be 
> used by going through the SCSI midlayer.  (This strikes me as analogous to 
> TCP/IP claiming ethernet and PPP devices so thoroughly that you can no longer 
> address them as eth1 or /dev/ttyS0.)

If you hate USB storage devices using scsi, please use the ub driver,
that is what it was written for.

> This has the annoying effect of bundling together different types of devices 
> and making device enumeration unnecessarily difficult: my laptop only has one 
> SATA hard drive and can't gain another without a soldering iron, but that 
> drive could move from /dev/sda to /dev/sdb if I reboot the system with a USB 
> key plugged in.  This seems like a regrettable loss of orthogonality to me.  
> I remember back when /dev/usb0 and /dev/hda were separate devices that showed 
> up in /dev, but these days "it's SCSI" seems to trump "it's USB", "it's ATA", 
> or "it's SATA".  (Even though none of those are actually SCSI hardware, they 
> just send a similar packet protocol across the wire.)

When did usb-storage devices ever show up as /dev/usb0?  USB flash disks
are really SCSI devices, look at the USB storage spec for proof of that.

thanks,

greg k-h

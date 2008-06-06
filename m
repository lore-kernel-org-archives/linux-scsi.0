From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 6 Jun 2008 16:42:06 +0200
Message-ID: <200806061642.07563.rjw@sisk.pl>
References: <200806010415.05290.chris2553@googlemail.com> <200806060607.29460.chris2553@googlemail.com> <1212761485.3466.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:32883 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbYFFOl2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2008 10:41:28 -0400
In-Reply-To: <1212761485.3466.6.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: chris2553@googlemail.com, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Friday, 6 of June 2008, James Bottomley wrote:
> On Fri, 2008-06-06 at 06:07 +0000, Chris Clayton wrote:
> > On Friday 06 June 2008, Andrew Morton wrote:
> > > On Sun, 1 Jun 2008 04:15:05 +0000 Chris Clayton <chris2553@googlemail.com> 
> > wrote:
> > > > Hi,
> > > >
> > > > I've just started testing 2.6.26 on my desktop machine and have found
> > > > that I get a long pause (20 seconds or so) as the system boots. By pause
> > > > I mean that the boot messages that normally scroll by stop doing so for,
> > > > as I say, about 20 seconds.
> > > >
> > > > I've done a bisect and arrived at:
> > > >
> > > > b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
> > > > commit b0ed43360fdca227048d88a08290365cb681c1a8
> > > > Author: Hannes Reinecke <hare@suse.de>
> > > > Date:   Tue Mar 18 14:32:28 2008 +0100
> > > >
> > > >     [SCSI] add scsi_host and scsi_target to scsi_bus
> > > >
> > > >     This patch implements scsi_host and scsi_target device types
> > > >     and adds both to the scsi_bus.
> > > >
> > > >     Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > >     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > >     Signed-off-by: James Bottomley
> > > > <James.Bottomley@HansenPartnership.com>
> > > >
> > > > :040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351
> > > >
> > > > 46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers
> > > >
> > > > The config file for that kernel is attached as are the kernel log for
> > > > booting that kernel and the bisect log.
> > > >
> > > > I've also noticed that it takes much longer for icons to appear on my
> > > > desktop when I plug a usb storage device in. (The icons are shown/hidden
> > > > by a simple sctript that is run via udev when the device is
> > > > attached/detached.)
> > >
> > > Do you believe that this is the same period?  20 seconds?
> > >
> > 
> > Thanks for the reply, Andrew. I was beginning to think that I'd committed an 
> > LKML sin :-)
> > 
> > Yes, it is about the same. On 2.6.25.4 (and earlier), the icons appear within a 
> > second or two, but with 2.6.26-rc2 or later, it takes about 20 seconds. I've 
> > now built and installed -rc5 and am seeing the same behaviour.
> > 
> > I've also built -rc5 on my laptop. On that my kernel uses the older IDE drivers 
> > rather than libata. The boot proceeds with no pause, but I do see the same 
> > delay in the desktop icons appearing when I attach a usb-storage device.
> > 
> > > > Let me know of any way I can help solve this.
> > > >
> > > > Please cc me to any reply as I'm not subscribed.
> > >
> > > cc's added.
> > >
> > > Rafael, we might need to track this as a post-2.6.26 regression.
> 
> It already is ... as I asked in the actual bug (but no-one seems to have
> noticed, so I assume the bug entry isn't set up correctly).

The bug reporter has no Bugzilla account, so I couldn't add him to the CC list
of the bug.

Thanks,
Rafael

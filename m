From: Fulko.Hew@sita.aero
Subject: Re: [linux-usb-devel] Re: [usb-storage] Malfunctioning USB stick
Date: Thu, 13 May 2004 16:54:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD1A9A657.BC5EF265-ON85256E93.00723324-85256E93.006C2644@yyz.sita.aero>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.sita.aero ([57.250.243.3]:17070 "EHLO mx2.sita.aero")
	by vger.kernel.org with ESMTP id S264518AbUEMUfX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 16:35:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org




Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag, 13. Mai 2004 20:09 schrieb Alan Stern:
> > On Thu, 13 May 2004, Oliver Neukum wrote:
> >
> > > Hi,
> > >
> > > this stick is acting up.
> > > I just mounted it and got (no disconnection physically):
> >
> > It looks like some sort of I/O problem reading the partition table.
What
> > do you get with verbose usb-storage debugging enabled?
>
> It turns out that the stick is defect. I've tested it on three computers
> and two operating systems. In fact during tests it got alarmingly hot.
> I think, there's little sense in further testing. It already turned up
> one little issue in the scsi code and I am impressed at the quality
> of our error handling :-)
> Now I'll have the pleasure the return it to the shop on a friday :-(

FWIW...

Once, while I was testing my laptop while trying to figure out
why hotplug no longer work on Fedora for me (and other distributions
work), I had left my stick plugged in even though it wasn't listed
on the USB bus (lsusb).  When I glanced down at it ~10 minutes
later, the 'green' led was orange.  And the stick was sooo hot,
you could burn yourself on it.  I unplugged it and let it cool down.
The stick still works, but... Something happening on the bus caused
it to get _real_ hot.





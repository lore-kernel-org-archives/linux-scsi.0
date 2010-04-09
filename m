From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 9 Apr 2010 14:54:39 -0700
Message-ID: <20100409215439.GA4779@xanatos>
References: <4BBF6B2F.9060902@gmail.com>
 <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1004091504500.1852-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 09, 2010 at 03:25:31PM -0400, Alan Stern wrote:
> On Fri, 9 Apr 2010, Jonas Schwertfeger wrote:
> 
> > On 04/09/2010 07:14 PM, Sarah Sharp wrote:
> > > Someone should probably tell Neil Perng at Genesys Logic.  Maybe Dinh
> > > Nguyen (from the launchpad entry) can provide an email address or
> > > forward this thread on?
> > 
> > Why are we sure that my drive has a chip by Genesys Logic in it at all? 
> >   I know that there are disks out there with that chip and that there 
> > are issues with it, but how did we conclude that the Buffalo drive has 
> > the same chip in it?  Is there a way for me to verify what chip is used 
> > without opening the case?
> 
> Now that you mention it, we don't know what sort of chip you have.  
> Only that the vendor ID is 0x0411 (MelCo., Inc.) and the product ID is 
> 0x0184.
> 
> I don't know of any way to find out what sort of chip it is without 
> opening the case (except perhaps by asking the manufacturer).

I've just opened the case on my Buffalo hard drive, and the circuit just
says Buffalo.  There's an ARM chip and a winbond chip, but not much else
to identify it.  I'll ask around the USB-IF PIL lab to try and get a
company contact.

Sarah Sharp

p.s. The Buffalo USB3 drive was much easier to open than the Dane-Elec
drive (and the hard drive and board was actually secured, unlike the
other drive).  There's a screw on the top, and if you pry off the
stickers on the bottom, there's some plastic clips holding the case
together.

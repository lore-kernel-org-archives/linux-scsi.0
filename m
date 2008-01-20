From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 16:45:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org>
References: <20080120205625.GB28842@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080120205625.GB28842-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 20 Jan 2008, Greg KH wrote:

> On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
> > Hi all,
> >
> > This patch sets the last_sector_bug flag to 1 for all USB disks. This is
> > needed to makes the cardreader on various HP multifunction printers work.
> >
> > Since the performance impact is negible we set this flag for all USB disks 
> > to avoid an unusual_devs.h nightmare.
> 
> Oh great, now my "working just fine" USB devices, which happen to have
> data in the last sector, suddenly stop working.
> 
> That's not acceptable :(

These patches really should not impact existing devices.  If they do
then something is definitely wrong.

Can you provide detailed logging information showing your problem?  For 
example, a usbmon trace would be good.  Better yet, a usbmon trace 
without the patches and a usbmon trace with the patches, for 
comparison.

Alan Stern

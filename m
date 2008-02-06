From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Wed, 6 Feb 2008 18:25:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802061820490.7110-100000@iolanthe.rowland.org>
References: <1202338869.3112.138.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1202338869.3112.138.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 Feb 2008, James Bottomley wrote:

> > What we're talking about is a routine that provides drivers a simple
> > way to access the data in a scatter-gather buffer (which may lie in
> > highmem or otherwise not be easily reachable).  The idea is that some 
> > commands are emulated by the driver rather than carried out by the 
> > device, and the driver needs some way to stick the results in the 
> > transfer buffer.
> 
> Isn't that what scsi_kmap_sg() is designed for ... or do you need
> something slightly different?

I don't know -- I've never heard of scsi_kmap_sg().  And it doesn't 
appear to exist anywhere in my kernel source.

Did you mean scsi_kmap_atomic_sg()?  That appears to do only part of
what usb_stor_access_xfer_buf() does.  In fact, all it does is map a
single page.

Alan Stern

From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Mon, 30 Jun 2014 09:28:10 -0700
Message-ID: <20140630162810.GF24179@kroah.com>
References: <Pine.LNX.4.44L0.1406301100300.1550-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1406301115010.1550-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1406301115010.1550-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 30, 2014 at 11:16:51AM -0400, Alan Stern wrote:
> On Mon, 30 Jun 2014, Alan Stern wrote:
>=20
> > Some buggy JMicron USB-ATA bridges don't know how to translate the =
=46UA
> > bit in READs or WRITEs.  This patch adds an entry in unusual_devs.h
> > and a blacklist flag to tell the sd driver not to use FUA.
> >=20
> > Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> > Reported-by: Michael B=FCsch <m@bues.ch>
> > Tested-by: Michael B=FCsch <m@bues.ch>
> > Acked-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > CC: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
> > CC: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>=20
> Greg:
>=20
> I forgot to add your name to the recipient list on this patch.  Since
> James has already Ack'ed it, would you like to take it for your USB
> tree?

Sure, I can take it, thanks.

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

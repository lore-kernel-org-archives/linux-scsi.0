From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Sun, 20 Dec 2009 12:31:10 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0912201226520.24162-100000@netrider.rowland.org>
References: <2f83750a0912200520l8e16fe6vdb436e67868c8f07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f83750a0912200520l8e16fe6vdb436e67868c8f07-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Clemens Fruhwirth <clemens-Yy/aLhJqNSaEi8DpZVb4nw@public.gmane.org>
Cc: Grant Grundler <grundler-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 20 Dec 2009, Clemens Fruhwirth wrote:

> On Wed, Dec 16, 2009 at 8:43 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLsd9G2dDO2Ms@public.gmane.org=
u> wrote:
>=20
> > Isn't just changing a block device's size at random times a bad thi=
ng
> > to do? =C2=A0The size gets used a for a bunch of different things (=
checking
> > partition boundaries, validating I/O block ranges, and so on).
>=20
> Forcefully extending partition boundaries and I/O block ranges was
> just what I had in mind. My card reader was listed as being compatibl=
e
> with card >1GB, and I suspected that this was only verified under
> Windows. I knew that Windows believed in the partition table more
> strongly than into device boundaries, so I figured that would probabl=
y
> work. And it did.

Just out of curiousity, what happens if you try to repartition and
format a card using this reader under Windows?  Does it restrict the
total available size to 1 GB?  If it does, doesn't that indicate the
reader _isn't_ compatible with large cards?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

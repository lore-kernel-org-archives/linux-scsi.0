From: Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>
Subject: Re: [usb-storage] PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Tue, 22 Jan 2008 09:26:16 +0100
Message-ID: <1200990376.7006.4.camel@localhost>
References: <47932211.90105@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47932211.90105-fbo2DhPpy/Q@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

Le dimanche 20 janvier 2008 =C3=A0 11:27 +0100, Hans de Goede a =C3=A9c=
rit :
> Hi all,
>=20
> This patch sets the last_sector_bug flag to 1 for all USB disks. This=
 is
> needed to makes the cardreader on various HP multifunction printers w=
ork.
>=20
> Since the performance impact is negible we set this flag for all USB =
disks to
> avoid an unusual_devs.h nightmare.
>=20
> Note that this patch depends on:
> PATCH: scsi-sd-last-sector-bug-flag.patch
>=20
> Which actually adds this flag to the scsi subsystem.
>=20
> Signed-off-by: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
>=20
> Regards,
>=20
> Hans

Just a line to say these new patches work for me.

Best regards,

Guillaume B.

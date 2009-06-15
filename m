From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 07:59:23 -0700
Message-ID: <20090615145923.GB15475@one-eyed-alien.net>
References: <4A363EB4.8000102@panasas.com> <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org> <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com> <4A365BBE.3010708@panasas.com> <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com> <3e7aae30906150750m6809aa87v35f739e0a72243d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e7aae30906150750m6809aa87v35f739e0a72243d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2009 at 08:20:10PM +0530, Ramya Desai wrote:
> > I can not post the code in public because of some limitations I have.
> >  But Still I am confused with return status (to SCSI layer) for the
> >  command while it is in progress, to get the next command. Is it some
> >  thing like PENDING?
>=20
> First command what I mean is some thing like READ(10) in general.
>=20
> I have taken only 10% the default mass storage driver to develop my
> custom driver as my device is entirely a new one. My driver and device
> both are capable of queuing the commands. But the problem is only with
> SCSI layer, which is not issuing next command (Like READ(10)) until
> the first one is done.

Did you change the maximum number of commands that the virtual HBA can
accept?  It's a field in the structure used when usb-storage registers
itself with the SCSI core...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's monday.  It must be monday.
					-- Greg
User Friendly, 5/4/1998

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKNmHLHL9iwnUZqnkRApQFAKCSRaMQBj+daUOIqqzloa52gtatLACgm3Jg
PxtWJehc9/0s5cvCpngBm2Y=
=KkQt
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

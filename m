From: Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Fri, 20 Jun 2008 07:14:45 -0700
Message-ID: <20080620141445.GA16839@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org> <200806191613.25552.david-b@pacbell.net> <20080620095311.GK15159@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20080620095311.GK15159-WfxVeM0IB4OcrO3FVCo2em/Xy1I+TMuj@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabor Gombas <gombasg-SuEj7oiQppWHXe+LvDLADg@public.gmane.org>
Cc: David Brownell <david-b-yBeKhBN/0LDR7s880joybQ@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2008 at 11:53:11AM +0200, Gabor Gombas wrote:
> On Thu, Jun 19, 2008 at 04:13:25PM -0700, David Brownell wrote:
>=20
> > Why give up, ever?=20
>=20
> It would be quite useful to time out and reboot using the previous
> kernel ("lilo -R") when one wants to figure out remotely why the new
> kernel does not boot.

And thus we arrive at only one conclusion:  You should do this with an
initrd so that any policy that is desired can be implemented.  No matter
what the kernel does by default, it will be incorrect for some scenarios.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIW7tVHL9iwnUZqnkRAsRGAJ9RnexoqKsfNBqW/WbGKwk5fm/TCwCdGlAV
bbvn4PaFBrXngbqa9zAiO5A=
=1bl4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

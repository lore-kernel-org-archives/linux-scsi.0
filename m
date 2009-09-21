From: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Subject: Re: Reducing the verbosity of inserting a USB storage device
Date: Sun, 20 Sep 2009 19:07:34 -0700
Message-ID: <20090921020734.GB10515@one-eyed-alien.net>
References: <20090920225348.GB3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090920225348.GB3690-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2009 at 04:53:49PM -0600, Matthew Wilcox wrote:
>=20
> The current kernel is very verbose when you insert a new USB storage
> device:
>=20
> [...]
>=20
> I think we can print a bit less information, and format it more densely.
> With the following three patches, my kernel prints:

Seems pretty reasonable, but perhaps we should put in a module parameter to
turn off the "quiet" flag?  The old data may be useful for debugging
purposes.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKtt/mHL9iwnUZqnkRAsX2AKCfZFwp31PJ0uf88tknj1aOjsBheQCfadIp
eDRykpf/ToQV/0oIqPKy6Zg=
=/jaz
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

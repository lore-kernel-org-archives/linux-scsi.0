From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
Date: Thu, 11 Nov 2010 09:43:22 -0800
Message-ID: <20101111174322.GB20296@one-eyed-alien.net>
References: <20101111165717.GA8526@kroah.com> <151524.65160.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151524.65160.qm@web31809.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 11, 2010 at 09:07:53AM -0800, Luben Tuikov wrote:
>=20
> Oh, I see. I'll re-post the patch then to Matthew and the people and list=
s you listed above.

Now that I'm on the CC, I see this.

What's the 10k-foot level summary here?  Is there an alternate sense-data
format that uses some sort of "descriptor" structure?  I'm assuming this is
a new SCSI-III thing, or did I just miss it in SCSI-II?

This *looks* like you're using functions provided by the SCSI core to
access and modify the sense data... so I'm assuming that's because there
are alternate formats...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFM3Cs63gL8qCooyc4RAueZAJ9jGVBPAAE3zD347PvhPkd2oXwkVgCfUf+r
qpnq01Eto5IpYc6mHJWOwR0=
=KhuC
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 23 Mar 2003 10:13:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323101314.E17056@one-eyed-alien.net>
References: <20030322233136.D17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222337260.5588-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303222337260.5588-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Mar 22, 2003 at 11:39:05PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2003 at 11:39:05PM -0800, Linus Torvalds wrote:
> How about making the SCSI stuff pass a "common" flag (or "required") down
> with the command? Then, a emulated thing could just decide to punt all=20
> commands with an immediate failure if they aren't marked "required".
>=20
> That still _allows_ the driver to implement it if it wants to, unlike you=
r=20
> previous approach.

That seems reasonable... but we need to define a standard way to
reject/fail non-common commands.  Special sense data?  Special result
code?  It doesn't really matter to me, but we need to pick something.

Do you have a preference?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ffk6IjReC7bSPZARAqrTAJ0YuSx9OjMUnufpvVinMpfxqL4YtgCgmuXr
DEjxKbaug3jCrNJRfy3j69Q=
=9Mkw
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--

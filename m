From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: use_10_for_ms revisited?
Date: Sat, 28 Jun 2003 23:38:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030628233824.H26995@one-eyed-alien.net>
References: <3EFE8784.4000101@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="0OWHXb1mYLuhj1Ox"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:24083 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265591AbTF2GYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 02:24:10 -0400
Content-Disposition: inline
In-Reply-To: <3EFE8784.4000101@pobox.com>; from jgarzik@pobox.com on Sun, Jun 29, 2003 at 02:30:28AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org


--0OWHXb1mYLuhj1Ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 02:30:28AM -0400, Jeff Garzik wrote:
> I was reading the specs just now, and I see that the inquiry page=20
> defines how ATAPI and USB devices indicate they are compliant with MMC-4.

It does?  I guess I've missed that.

If you're talking about the INQUIRY command, the data better be within the
first 36 bytes, or it's likely to not actually be there.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Umm, these aren't the droids you're looking for.
					-- Bill Gates
User Friendly, 11/14/1998

--0OWHXb1mYLuhj1Ox
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+/olgIjReC7bSPZARApf7AKC/l79mrX9xWm10P2GaE4q3EQUUPACg044F
Q7/nEKbndLD3Kx1CS6urB4I=
=7C/5
-----END PGP SIGNATURE-----

--0OWHXb1mYLuhj1Ox--

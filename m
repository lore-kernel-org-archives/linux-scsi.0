From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Mon, 23 Jun 2003 10:30:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623103041.B3610@one-eyed-alien.net>
References: <1056241551.1775.14.camel@mulgrave> <20030621174640.M2811@one-eyed-alien.net> <1056250487.1775.58.camel@mulgrave> <20030621212406.N2811@one-eyed-alien.net> <1056290282.1979.4.camel@mulgrave> <20030622124917.A21716@one-eyed-alien.net> <20030622125650.D21716@one-eyed-alien.net> <1056314343.10846.93.camel@mulgrave> <20030622140657.A22396@one-eyed-alien.net> <1056378827.1826.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:10511 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S266076AbTFWRQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 13:16:37 -0400
Content-Disposition: inline
In-Reply-To: <1056378827.1826.14.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Jun 23, 2003 at 09:33:45AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2003 at 09:33:45AM -0500, James Bottomley wrote:
> Have you actually heard of setting DBD causing a failure on ATAPI
> devices?

I believe I have, but I can't site anything solid.  Which means (likely)
that there were multiple possible explanations.

We've changed a lot of MODE_SENSE code, and it's difficult to separate out
what was causing the problem.  And I'm constantly finding devices with new
and more creative ways to not work right.

In short: I guess I'm not really certain.  So let's go ahead and try it.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9zlBIjReC7bSPZARAlbgAJ9fN0NXSIUelGIhKLWjYVC+BBSELwCgiARx
wmigWJBDq/gtcBy5pKvGksY=
=7V1O
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

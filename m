From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Is scsi_cmnd::underflow still useful?
Date: Mon, 12 Jul 2004 22:09:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040713050920.GA31062@one-eyed-alien.net>
References: <40F2E93B.3040607@torque.net> <1089680114.2074.198.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:35729 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263824AbUGMFKa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 01:10:30 -0400
Content-Disposition: inline
In-Reply-To: <1089680114.2074.198.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bunk@fs.tum.de


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 12, 2004 at 07:55:13PM -0500, James Bottomley wrote:
> On Mon, 2004-07-12 at 14:40, Douglas Gilbert wrote:
> > Doesn't look like many LLDs act on scsi_cmnd::underflow.
> > Seems to me that scsi_cmnd::resid is a more general
> > replacement.
>=20
> well, I know I suggested a recent use of it to the USB people , so I
> don't think it's entirely unused.  resid can't be a replacement because
> they mean different things:
>=20
> resid - number of bytes left over after a transaction
> underflow - driver must return error if less than this amount
> transferred.

I think the recent USB usage of it was because some mid-level drivers look
for the error condition related to the underflow value.

We don't really use it, other than to trigger an error.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Stef, you just got beaten by a ball of DIRT.
					-- Greg
User Friendly, 12/7/1997

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFA826AIjReC7bSPZARAg9UAJ0cyE/acBAR/s7zkLzOPFWR4H1BJwCgl+8U
g9AF4E4PCthEPaXvpk0nKog=
=U10g
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--

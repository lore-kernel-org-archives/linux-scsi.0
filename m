From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 5 Apr 2003 16:22:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030405162234.E4320@one-eyed-alien.net>
References: <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030405112759.B4320@one-eyed-alien.net> <1049571946.2538.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:4871 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262736AbTDFALO (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 19:11:14 -0500
Content-Disposition: inline
In-Reply-To: <1049571946.2538.94.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 05, 2003 at 01:45:43PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2003 at 01:45:43PM -0600, James Bottomley wrote:
> What's wrong with
>=20
> -		if(scsi_filter_cmd(SCp, &filter)) {
> +		if(SCp->device->type =3D=3D TYPE_DISK && scsi_filter_cmd(SCp, &filter)=
) {
>=20
> ?

Out of curiosity, at what point is SCp->device->type a valid reference?  I
would hope that none of those pointers would be NULL during a probe at init
time.  I also hope that the type field contains the right data as soon as
the INQUIRY data comes back... but does anyone actually know for certain?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Pitr!  That's brilliant!  Funded by Microsoft refunds.  What sweet irony!
					-- A.J.
User Friendly, 2/15/1999

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+j3NKIjReC7bSPZARAkIIAJ9rn3e7rYx+eCBnch3miVTPA5Ov2gCfTcji
adRPyYYrt+97A7LiccdtlG0=
=iMSE
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--

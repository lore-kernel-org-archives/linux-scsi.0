From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: scsi mode sense broken again
Date: Fri, 4 Jul 2003 14:09:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030704140934.B18450@one-eyed-alien.net>
References: <UTC200307042108.h64L86P22656.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:57863 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S266188AbTGDUzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2003 16:55:08 -0400
Content-Disposition: inline
In-Reply-To: <UTC200307042108.h64L86P22656.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Fri, Jul 04, 2003 at 11:08:06PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2003 at 11:08:06PM +0200, Andries.Brouwer@cwi.nl wrote:
> 	From mdharm@ziggy.one-eyed-alien.net  Fri Jul  4 23:00:41 2003
>=20
> 	Do you still get the proper INQUIRY from 2.5.74?
>=20
> Yes. But there is no need for you to worry.
> This device just needs use_10_for_ms =3D 0.
> When that is set all is well.

Okay, so the question as I see it is this:  Do we go back to use_10_for_ms
=3D 0 for the default, or do we make the IMM driver set it to 0 in the
slave_configure() function?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Type "format c:"  That should fix everything.
					-- Greg
User Friendly, 12/18/1997

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/Be0OIjReC7bSPZARAhy3AKCC+jpw9MNjGm10eVGvpue896EpcQCeMWKA
+R4uv25X/ssBHalNhZfTRWM=
=CfHD
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Fusion-MPT with 53C1030 and no flash?
Date: Fri, 8 Oct 2004 12:56:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041008195648.GA5719@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:20623 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263664AbUJHT4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2004 15:56:49 -0400
Received: from multivac.one-eyed-alien.net (localhost.localdomain [127.0.0.1])
	by multivac.one-eyed-alien.net (8.12.8/8.12.8) with ESMTP id i98Jum8o006843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 8 Oct 2004 12:56:48 -0700
Received: (from mdharm@localhost)
	by multivac.one-eyed-alien.net (8.12.8/8.12.8/Submit) id i98Jum5I006841
	for linux-scsi@vger.kernel.org; Fri, 8 Oct 2004 12:56:48 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Has anyone ever used an LSI 53C1030 chip WITHOUT attached flash?

As I read the technical docs, it's possible... but it requires a driver
which can download the firmware to the ARM processor.  It looks like the
current 2.6.x driver can't do that.

In fact, I can't seem to locate a suitable firmware image anywhere...

Does anyone have any experience in this area they could share?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBZvEAIjReC7bSPZARAkDIAJ9rdnDfeE8catn1zQ246qse6fxu2wCgudjF
PnDgs5WsrKtUrbckiwXGf9A=
=4xT2
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Time to conclude the Sony USB mass storage thread
Date: Fri, 14 Nov 2003 10:52:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114105212.C19467@one-eyed-alien.net>
References: <1068825146.2134.6.camel@mulgrave> <20031114092644.A2794@beaverton.ibm.com> <20031114093503.B19467@one-eyed-alien.net> <20031114095823.A3597@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:62226 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264583AbTKNSwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 13:52:20 -0500
Content-Disposition: inline
In-Reply-To: <20031114095823.A3597@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Nov 14, 2003 at 09:58:23AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, usb-storage@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 09:58:23AM -0800, Patrick Mansfield wrote:
> On Fri, Nov 14, 2003 at 09:35:03AM -0800, Matthew Dharm wrote:
> > I think I'd rather tweak the structure in slave_configure, where it wil=
l be
> > easier to add more logic if people decide we need it in the future.
>=20
> Unlike scsi_devinfo/dev_flags, we can't override slave_configure changes
> (unless you add other code).

It's not immediately clear how we can override it if it's
scsi_devinfo/dev_flags.  Can you elaborate?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tSRcIjReC7bSPZARAqEUAJsE5jVfE1KeOrK63HW3WRK3qbUxWwCfZnB8
RRb/xLQf5YGviL4IowHMM68=
=MxWk
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--

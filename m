From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: bug 2400
Date: Thu, 1 Apr 2004 15:07:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401230740.GB3820@one-eyed-alien.net>
References: <20040401131502.41136788.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:28624 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263317AbUDAXHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 18:07:44 -0500
Content-Disposition: inline
In-Reply-To: <20040401131502.41136788.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 01, 2004 at 01:15:02PM -0800, Andrew Morton wrote:
>=20
> Apparently there is some controversy over whether this:
> http://bugme.osdl.org/show_bug.cgi?id=3D2400 is a usb-storage problem or a
> SCSI problem.
>=20
> Can someone please shed some light, propose a way to get it fixed?

There's controversy over this?

It looks pretty clearly to be a SCSI or CD-ROM bug, not a usb-storage bug.
The OOPS looks like it's all about object handling, and usb-storage does
nothing directly with objects.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Why am I talking to a toilet brush?
					-- CEO
User Friendly, 4/30/1998

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAbKC7IjReC7bSPZARAqnlAKCLHujr6FdqJTf/VaUsOiEkh52Q/ACgkWlJ
x5VClYWh0nfCO+lhPfg7I4E=
=dXGI
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] yet another patch to limit mode sense usage
Date: Mon, 15 Sep 2003 13:45:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915134513.A31961@one-eyed-alien.net>
References: <20030915132330.A9823@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:62986 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261620AbTIOUqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 16:46:08 -0400
Content-Disposition: inline
In-Reply-To: <20030915132330.A9823@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Sep 15, 2003 at 01:23:30PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2003 at 01:23:30PM -0700, Patrick Mansfield wrote:
> Patch to allow overriding or setting of mode sense related flags, includes
> Alan Stern's as95 patch minus his scsiglue.c changes.
> +	/* modify scsi_device bits on probe */
> +	.flags =3D (BLIST_MS_SKIP_PAGE_3F | BLIST_USE_10_BYTE_MS),
> +

In my view, the problem isn't page 0x3F, but page 0x8.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Oh great modem, why hast thou forsaken me?
					-- Dust Puppy
User Friendly, 3/2/1998

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/ZiTZIjReC7bSPZARArWUAKC/Kj8qBTZJDCL2zh0GiG5DpgItgQCgxzmO
wgr6E8ilGqLaNbojT2NgU8s=
=eTUD
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

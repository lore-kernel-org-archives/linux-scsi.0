From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] 2.4.27rc2, DVD-RW support broke DVD-RAM writes
Date: Sun, 1 Aug 2004 16:53:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040801235357.GB18403@one-eyed-alien.net>
References: <20040730153657.GB2748@logos.cnet> <20040731163334.GH23697@suse.de> <76A380F2-E3C5-11D8-B01E-00039398BB5E@ieee.org> <06E9D950-E3EF-11D8-B976-00039398BB5E@ieee.org> <70B2077E-E401-11D8-B976-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:50136 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S266200AbUHAXyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 19:54:17 -0400
Content-Disposition: inline
In-Reply-To: <70B2077E-E401-11D8-B976-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, "usb-storage@lists.one-eyed-alien.net list" <usb-storage@lists.one-eyed-alien.net>


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 01, 2004 at 03:26:24PM -0600, Pat LaVarre wrote:
> Jens A/ Matt D:
>=20
> Linux 2.4.27-rc4 and 2.4.26 do Not recognise USB DVD-RAM disc=20
> rewritability, even though 2.4.27 has recognised USB Iomega REV disc=20
> rewritability at least since -rc3.
>=20
> Q0: Agreed?

I'll take your word for it.

> Q1: Would you consider a promptly written patch to persuade 2.4.27-rc4=20
> to recognise USB DVD-RAM rewritability?  Or is 2.4 development already=20
> too over?

I've turned over 2.4 maintance to Pete Zaitcev.

> Q2: Where do you want the patch?  In drivers/usb?  In drivers/scsi?

To me, it sounds like drivers/scsi would be better.  Tho I can see good
arguments for either location.

> Q3: What patch do you want? Should we try op x5A after op x1A fails? =20
> Or should we try only op x5A?  Or should we try op x5A first?

I would think on a SCSI Level 2 device, we should start with x5A.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBDYKVIjReC7bSPZARAqK0AJ0VgoXiG5Ml5e92b6sfiEk9nHDeWgCgguAP
mACUW/R8TKFBb4pwcDnt9og=
=X0vo
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--

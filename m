From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
Date: Tue, 29 Dec 2009 21:02:42 +0100
Message-ID: <200912292102.43373.eike-kernel@sf-tec.de>
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1699455.DbQ32g4QYV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:58442 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbZL2UCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2009 15:02:48 -0500
In-Reply-To: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

--nextPart1699455.DbQ32g4QYV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> In each case, the destination of the allocation has type struct **, so the
> elements of the array should have pointer type, not structure type.

Maybe they should even by kcalloc'ed?

Eike

--nextPart1699455.DbQ32g4QYV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAks6YGMACgkQXKSJPmm5/E6KCQCgnrkOEo9hY7DsSefSyUa1QSdj
2isAn2F4oFROAFlqgHz5UWGrRjyh+yGp
=scYj
-----END PGP SIGNATURE-----

--nextPart1699455.DbQ32g4QYV--

From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: i450nx-scanning-fix.patch
Date: Mon, 29 Dec 2003 12:38:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072697933.5223.15.camel@laptop.fenrus.com>
References: <20031229030235.315d5502.akpm@osdl.org>
	 <1072697054.5223.12.camel@laptop.fenrus.com>
	 <20031229032759.26802292.akpm@osdl.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k5NUxj4YifnKr3C3JATE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:48770 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S263303AbTL2LjG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:39:06 -0500
In-Reply-To: <20031229032759.26802292.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: willy@debian.org, linux-scsi@vger.kernel.org


--=-k5NUxj4YifnKr3C3JATE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>=20
> Thus leaving me even-more-confused-than-usual.  Ho hum.
>=20
> Was your fix equivalent to this patch?

not fully (looking waay back into kernel rpms ....)... the one I had was
a bit simpler in concept so this one might actually work better.

Also the problem wasn't "it doesn't work at all" it was "this ONE pci
slot isn't visible" which is why it going wrong escaped QA....=20

--=-k5NUxj4YifnKr3C3JATE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/8BJNxULwo51rQBIRAq9XAKCQNDCjGsBCN2n+eVU9k2zLqNFm4gCffutb
MttP/sFPwrzD31H77J1um8I=
=kRKT
-----END PGP SIGNATURE-----

--=-k5NUxj4YifnKr3C3JATE--

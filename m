From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: i450nx-scanning-fix.patch
Date: Mon, 29 Dec 2003 12:24:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072697054.5223.12.camel@laptop.fenrus.com>
References: <20031229030235.315d5502.akpm@osdl.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8hldx/BYqn3SWlNLBDq7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:32386 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S263345AbTL2LY0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:24:26 -0500
In-Reply-To: <20031229030235.315d5502.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org


--=-8hldx/BYqn3SWlNLBDq7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-12-29 at 12:02, Andrew Morton wrote:
> I have had this in -mm for some time.  It works on my 450nx-based 4-way.=20
> Was planning on merging it.  Speak now or forever hold your pieces.

the one thing I can say is that I had a "fix" for this in the RH kernel
for a while, but it broke with newer bioses. End result was that there
was a working kernel for either old or for new bioses; the existing
linux worked well for newer bioses so I just dropped the patch entirely.
(Several machines only come with newer bioses and most people with old
bioses had updated anyway, probably for y2k issues :)


--=-8hldx/BYqn3SWlNLBDq7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/8A7exULwo51rQBIRAm5ZAJ90jYGZukUVHUWKq5oDViiCNz582gCdFgaV
ym9JrFpX6GxFQKroE/Rq2Do=
=CLRX
-----END PGP SIGNATURE-----

--=-8hldx/BYqn3SWlNLBDq7--

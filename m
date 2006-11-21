From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] Remove #warning cruft from drivers/scsi/ips.c
Date: Wed, 22 Nov 2006 10:57:30 +1100
Message-ID: <1164153450.8090.2.camel@localhost.localdomain>
References: <20061121061413.5D10967BF3@ozlabs.org>
	 <1164122214.2808.1.camel@mulgrave.il.steeleye.com>
Reply-To: michael@ellerman.id.au
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c08dA/iATCRm2c5GCl4d"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:8426 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S1756889AbWKUX5b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 18:57:31 -0500
In-Reply-To: <1164122214.2808.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, ipslinux@adaptec.com


--=-c08dA/iATCRm2c5GCl4d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-11-21 at 09:16 -0600, James Bottomley wrote:
> On Tue, 2006-11-21 at 17:14 +1100, Michael Ellerman wrote:
> > drivers/scsi/ips.c pollutes my build log telling me that it has only
> > been tested on x86/ia64/x86_64. It's starting to get annoying.
>=20
> Since we have a failure report for this driver on the ppc platform, I
> don't necessarily see the warning as being inappropriate.

If it's known not to work, why are we building it at all for ppc?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-c08dA/iATCRm2c5GCl4d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFY5JpdSjSd0sB4dIRAh7TAJ444tBnCyBCwwqs0abX2e/m6soSEwCdFjqk
gYFAIhBOTol9qeImI4VsviU=
=KzDI
-----END PGP SIGNATURE-----

--=-c08dA/iATCRm2c5GCl4d--


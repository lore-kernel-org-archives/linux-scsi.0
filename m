From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6 patch] fix aic7xxx_old.c for !PCI
Date: Thu, 13 May 2004 09:41:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084434113.2781.6.camel@laptop.fenrus.com>
References: <20040512235555.GF21408@fs.tum.de>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7SNQo3iRIcbNGT+8tjGU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47749 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263881AbUEMHm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 03:42:56 -0400
In-Reply-To: <20040512235555.GF21408@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--=-7SNQo3iRIcbNGT+8tjGU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-05-13 at 01:55, Adrian Bunk wrote:
> I got the following compile error in 2.6.6-mm1 (but it's not specific to=20
> -mm) with CONFIG_PCI=3Dn:

or how about just providing a dummy pci_release_regions() for the !PCI
case ?

--=-7SNQo3iRIcbNGT+8tjGU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD4DBQBAoybAxULwo51rQBIRAjHOAJiUaMAFy6/lSgpzUbNrPOdJBGGZAJ9jWTVr
A3qu5QSQ+q33oEZiMBJZgQ==
=uzO8
-----END PGP SIGNATURE-----

--=-7SNQo3iRIcbNGT+8tjGU--


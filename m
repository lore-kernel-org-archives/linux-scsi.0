From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 05 Apr 2004 12:02:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081159378.4679.1.camel@laptop.fenrus.com>
References: <40712A47.4090903@shadowconnect.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jCODR1tkDDEe5AlD6Zx0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:11142 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261880AbUDEKDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 06:03:05 -0400
In-Reply-To: <40712A47.4090903@shadowconnect.com>
List-Id: linux-scsi@vger.kernel.org
To: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: linux-scsi@vger.kernel.org


--=-jCODR1tkDDEe5AlD6Zx0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-04-05 at 11:43, Markus Lidel wrote:
> Hello,
>=20
> This patch allows Adaptec's management software (raidutils) to work with=20
> the I2O subsystem with DPT RAID hardware.  The previous release of=20
> raidutils from Adaptec works only with the obsolete dpt_i2o driver in=20
> the 2.4.x kernel.  Adaptec has since released raidutils under the BSD=20
> license, and development of raidutils will proceed at the new I2O=20
> development homepage:

is there a convincing argument why this can't use the SG_IO mechanism
instead of a device private ioctl ?

--=-jCODR1tkDDEe5AlD6Zx0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAcS7SxULwo51rQBIRAh7ZAJ9kbEwT6HVMTWPLaGFvmpaQ4k+xwACbBLe/
deeZPyuRDDDCIYD+CuZ6WeY=
=ksZG
-----END PGP SIGNATURE-----

--=-jCODR1tkDDEe5AlD6Zx0--


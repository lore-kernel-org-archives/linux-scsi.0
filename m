From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: [PATCH] scsi: megaraid_{mm,mbox} cmd timeout
Date: Thu, 1 Feb 2007 08:01:49 +0100
Message-ID: <20070201070149.GQ16848@kiste.smurf.noris.de>
References: <0631C836DBF79F42B5A60C8C8D4E82298ECBCC@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smurf.noris.de ([192.109.102.42]:39316 "EHLO smurf.noris.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161253AbXBAHYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 02:24:35 -0500
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E82298ECBCC@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Patro, Sumant:
> What I see in the log is cmd timeout(s) and is not related to the patch.
>=20
Ouch.

Any ideas what causes my problem? It's a regression; I tested Ubuntu
Dapper and Edgy install CDs, and it's not worked since the latter.

I can pinpoint the change that triggers the problem more closely if
necessary.

--=20
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
My father was a God-fearing man, but he never missed a copy of the
New York Times, either.
		-- E.B. White

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFwZBd8+hUANcKr/kRAsN9AJ0WjgKt3P0z5t99qsm8k1H+xIeZdwCdHZIw
8csg6UPaSVc/QvJteNoBcU0=
=76uI
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--

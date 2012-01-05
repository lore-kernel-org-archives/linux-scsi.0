From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] firmware/isci: update to oem parameter format v1.3
Date: Thu, 05 Jan 2012 13:22:54 +0000
Message-ID: <1325769774.13595.282.camel@deadeye>
References: <20120104092339.8562.74674.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-miKuzGCdmxZb7bNEKb91"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48415 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756821Ab2AENXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2012 08:23:11 -0500
In-Reply-To: <20120104092339.8562.74674.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org


--=-miKuzGCdmxZb7bNEKb91
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-01-04 at 01:25 -0800, Dan Williams wrote:
> v1.1 allows finer grained tuning of the SSC (spread-spectrum-clocking)
> settings for SAS and SATA.  See notes in probe_roms.h
>=20
> v1.3 allows the attenuation of the attached cables to be specified to
> the driver in terms of 'short', 'medium', and 'long' (see probe_roms.h).
> These settings (per phy) are retrieved from the platform oem-parameters
> (BIOS rom), the fallback firmware blob, or via a module parameter
> override.
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-miKuzGCdmxZb7bNEKb91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwWkL+e/yOyVhhEJAQrIyBAAwESuTPBMcrVcGwf1p+PUUoOH9W9yUYJk
aRmFiC0y2Di6I4elxVKZJoNnupetnCSzfgZdGbdyWCZ4+tW4cinimKUnxEXt6sqE
9iV3hXYst4e0ZXx/L+FQ2rSQN2qEuWmYeGrRNoHMgRpnUHNXyfaWvPwOo3uCUySx
yOb3jFYdAlfPYBTQQzxU6FemlaylKOAhutgJCzH+DJG22V8ct0+YpWwdhJYqpjll
e8a5EvJj8UK+/nCwn6BQ2xjYdtwo3tCW20SElV/30cRdy71MCYDj29+fBcRe1AwP
JvbJ/EQMx2lWOHyVkKpkDpZTVwWVOsdawYsK/PscmgguEMVAYhCymzu7kPIVUqjn
74XgaUkKY5M5Vjq2w4upToO4wR8c8XEImSlQIs/qBLA8XmArz75qKC8Hb+CMRSTd
5rLUcuTVRgzWN4rZ1rStiDIGFGXFZFDH7+3i+eJPc17lKiKY9D0cxlrmzP/Ji5WJ
zIlalf/pv1yeqnI4hU6KtaVgJfaUvvDQpszISkIQowk4S7MtF0nAo9KDF/NmrF8g
xqp5PKOxpT+jX5DaJTLb/rpDsN5XLJme+GjjoNhuvf3Nl3axiBbgie7G0a6HY/zw
E6L/eELDIv+31Q/KqMR02Kbn78QEN6LBYQbM5/5RfB3D3LsOGeXtX4KUXBZiyS3W
ky4SiLx3azs=
=V+f9
-----END PGP SIGNATURE-----

--=-miKuzGCdmxZb7bNEKb91--

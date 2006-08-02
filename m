From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Wed, 02 Aug 2006 16:52:31 +0200
Message-ID: <44D0BC2F.3030700@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange> <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7815BD8C39AD96C55C11EA56"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-03.sil.at ([86.59.12.202]:5323 "EHLO mx-03.sil.at")
	by vger.kernel.org with ESMTP id S1751155AbWHBOwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 10:52:49 -0400
In-Reply-To: <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7815BD8C39AD96C55C11EA56
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/02/06 12:11, Guennadi Liakhovetski wrote:
>=20
> Yes, this is only present in 2.6.18. And what transfer rates are you=20
> getting with this workaround without safe=3D1? Compared to safe=3D1 and=
 to=20
> other controllers / drivers?

Unfortunately I currently don't have another SCSI controller around
(only onboard or broken ones).

I tested with 2.6.18-rc3.
"dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1024" (for read)
"dd if=3D/dev/zero of=3D/dev/sda bs=3D1M count=3D1024" (for write)
each 5 times (results were almost the same.. maximum difference was 0,1mb=
/s)

default arguments: ~37,5mb/s (read) ~37,6mb/s(write)
safe=3D1: ~2,8mb/s (read) ~2,3mb/s (write)

Regards,
Robert


--------------enig7815BD8C39AD96C55C11EA56
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTQvDIACgkQVoNfMxmfyFNE7QCfbT5abYvn0oXFUUiP0kwFlo3E
M0MAnRcAnuitbOc1fmN1j0peF4S2xVZv
=3i3E
-----END PGP SIGNATURE-----

--------------enig7815BD8C39AD96C55C11EA56--

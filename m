From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Wed, 02 Aug 2006 11:51:30 +0200
Message-ID: <44D075A2.2080501@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBB7BA9613A19D45423F7BC8B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-03.sil.at ([86.59.12.202]:30621 "EHLO mx-03.sil.at")
	by vger.kernel.org with ESMTP id S1751345AbWHBJvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 05:51:44 -0400
In-Reply-To: <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBB7BA9613A19D45423F7BC8B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/02/06 01:24, Guennadi Liakhovetski wrote:
> a) uncommenting the line
>=20
> #define DC395x_NO_TAGQ

I forgot to mention:
Using this workaround works with 2.6.16 and does not trigger bug().

Regards,
Robert


--------------enigBB7BA9613A19D45423F7BC8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTQdaIACgkQVoNfMxmfyFMcswCeKjpWs6yHitgd6++ih3xhJgas
7uQAn1v3RpeJEG57F7YOukGaWLZeuWl1
=X2sT
-----END PGP SIGNATURE-----

--------------enigBB7BA9613A19D45423F7BC8B--

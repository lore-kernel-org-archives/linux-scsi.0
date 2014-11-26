From: Mark Brown <broonie@kernel.org>
Subject: next-20141126 build failures in wd719x
Date: Wed, 26 Nov 2014 17:26:06 +0000
Message-ID: <20141126172606.GL7712@sirena.org.uk>
References: <E1XtdBa-00087r-J4@debutante>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L5Ks5Ey27iMz7PUy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39579 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaKZR22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2014 12:28:28 -0500
Content-Disposition: inline
In-Reply-To: <E1XtdBa-00087r-J4@debutante>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org


--L5Ks5Ey27iMz7PUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2014 at 02:03:14PM +0000, Build bot for Mark Brown wrote:

The wd719x driver fails to build on at least arm and arm64 in today's
-next since:

> 	arm64-allmodconfig
> ../drivers/scsi/wd719x.c:247:2: error: implicit declaration of function '=
dma_cache_sync' [-Werror=3Dimplicit-function-declaration]
>=20
> 	arm-allmodconfig
> ../drivers/scsi/wd719x.c:247:2: error: implicit declaration of function '=
dma_cache_sync' [-Werror=3Dimplicit-function-declaration]

dma_cache_sync() is not available on these architectures.  I can't
immediately see something to depend on that'd exclude the driver from
these architectures, the other users seem to all have architecture
specific dependencies.

--L5Ks5Ey27iMz7PUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdg0uAAoJECTWi3JdVIfQa2YH/RlpX9CZUj7mxuc0zeV7JA9g
6pXZ9f3ssWrn/bp6CevE4mgGe1B8qry1COS937UJX7xaZispE+UjwtwBgOb+Fhnv
iOgsjGd3MKFO6uG/OG3/2DOSmnWw7+L95YA1pheI7yOhlvy884jloMXzCUw8WXw+
dF0mlLDkTFbyZd2r9uyKvYU8xHAWusneifN7rKQE7ilGXn3xMC8z8J1XQnBtY9Sw
zk1yFLO0+mWFZgcvpuOv8BUZ+5XtrQz6V8/5X4Lf442s8TS/ihtcsg9F1Rld4Ajw
Ov//Z6gSOH0eri7yUvwFZZHMqfHhJDrrRCX2aaKPw+s9vbyVGuFNVWjqg+cXyeo=
=o/9w
-----END PGP SIGNATURE-----

--L5Ks5Ey27iMz7PUy--

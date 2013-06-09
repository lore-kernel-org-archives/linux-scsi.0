From: Ben Hutchings <ben@decadent.org.uk>
Subject: [SCSI] ufs: Add missing dependency on CONFIG_HAS_IOMEM
Date: Sun, 09 Jun 2013 21:04:34 +0100
Message-ID: <1370808274.5614.10.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-W31E72mh7h7kJAO93B0B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56321 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab3FIUEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 16:04:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-s390@vger.kernel.org, stable@vger.kernel.org


--=-W31E72mh7h7kJAO93B0B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The ufs driver doesn't build on s390 with CONFIG_PCI disabled as it
requires MMIO functions.

Marking for 3.9-stable only as CONFIG_SCSI_UFSHCD was previously
dependent on CONFIG_PCI.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org # 3.9
---
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -34,7 +34,7 @@
=20
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller Driver Core"
-	depends on SCSI
+	depends on SCSI && HAS_IOMEM
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card


--=-W31E72mh7h7kJAO93B0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbTf0ue/yOyVhhEJAQpF/xAArX9TH4T9NQ3doxLih5pV7VTumYT7M2S/
RlMaLpB9ZilPy90dErSf2/JFvrvPJsIVga9BV+sj9Oz2hAZHAILLgjWTjwi9Kh9i
dzMf0ztq7hDMyXw9YnK7/iwRA3Y/sQcXm9xV3dYSBExWyi6JMVWEU18aRy6nmrh4
bi/rdehBI5MbBFAfwblPMNIZyzITprQ6Nq5z3FZZQKSYhkoNtr1VHFtaKsCkK5TM
SNq4+mDrChjOL0ljw1KlBOE8gGGCjaF68C1NCcWE5Iu7DpwwMUdaRXbJquqETAUz
q8viDDkSrxTEn+dQiPvYikQyEmDvYsN3xBIyWd34mV2B+7uJB66cBR+3ZRd4OMcZ
e6UOPLzOoP1/xrTDwQVM9OHpPZIMLm9NdxSxSHd6AI7COsSg+ZXEVoApYjcecAyf
EFC2yaoUrdezj6tMY0pNbsN7Nwu8s4OUtXu7JhXXHDYGwdB6OIdedrta3qP0VEQh
YRCEgTJCXr1J+PYfWEIzFrIociplyUc93mqD5YWmdbz3HX657XURDWxbOlNKjr0m
PNlVvWr3dmXP4m1AVUOYDgIvlJJV0ie8VXGEZJMnTEKWRl6A3mKclvu+wYamMbiU
acSYzwp8hgTcnoO/l7fznnP9IjxBNeoEtg90Jj5uHPJyC0HiIDOSnF6G8bYeR4L+
8JDPIdLHn08=
=c41M
-----END PGP SIGNATURE-----

--=-W31E72mh7h7kJAO93B0B--

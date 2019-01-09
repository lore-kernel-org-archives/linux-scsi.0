From: Otto Sabart <ottosabart@seberm.com>
Subject: [PATCH 1/1] doc: scsi: remove reference to tmscsim.txt file
Date: Wed, 9 Jan 2019 20:08:56 +0100
Message-ID: <ca9292ddbe567ae841b6c7e2d27e011ce078442d.1547059763.git.ottosabart@seberm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The tmscsim.txt doc file was removed in c121107d0f84.

Fixes: c121107d0f84 ("scsi: documentation: Obsolete documentation reference=
s")
Signed-off-by: Otto Sabart <ottosabart@seberm.com>
---
 drivers/scsi/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f38882f6f37d..6cbc391689ad 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1196,8 +1196,6 @@ config SCSI_AM53C974
 	  PCscsi/PCnet (Am53/79C974) solutions.
 	  This is a new implementation base on the generic esp_scsi driver.
=20
-	  Documentation can be found in <file:Documentation/scsi/tmscsim.txt>.
-
 	  Note that this driver does NOT support Tekram DC390W/U/F, which are
 	  based on NCR/Symbios chips. Use "NCR53C8XX SCSI support" for those.
=20
--=20
2.17.2


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEb6VOpv2s03VHGoilgjuumfi+HjwFAlw2RskACgkQgjuumfi+
Hjw3+g/+Jh1Q4kLq9CF9gScycehJ7G0m69m6N3NmMx8fk9N0OnbZ/AJ7ss/e2qBB
LOogQEcer1egzYUdIe48IPZcV0hiwDstYaiTAjOWSA3v4GyvysxvzChVUtUztwuT
Qmztb0vcIdCLNGZGLMMZXDCh4BqG7cdO3TKZpoM6jlE/yiUitScJ7BOGXnbdkEkG
o6g+yWos7DajCaNKOxXIDCe7iSc2AIOLMmZg8D45EKX1+cn4JXXIQ9rUaDbxYlG+
kaNGjrB0X8OKBODeqfh61WPfe44l4Vc0Mv/dY0W4Do1iZppp0Og47klsxDO3dz3k
LPZIZfY0lMiV20tvEhRft0cm51HV/iScrzveYEVxi/ppgvQElXWZtEo1tjJVOlgh
zqNspvDHQxfSvRkVcJhD1+hAvjl4183Ta6i6BctJ5+bKX5/28QY62gLKFU4P5g6y
51e7q0P4eLzNlRYfAwdywONs8/H9oupowVVtsEal+L2YaoFsl2oJZWF8doU9filT
kicF8ROH4xOHFJL/ftQ90FYrzoKZVnHHP5zz3tZO957ZzKNfiBWWhUGymNXExTAS
xP4d43tuecCDiZD0GWFNcO+avNLq0ERJovJ0P0cPhhvkdt+pZA2Gj9nxfkv55Riy
cn1inLpx2yO+8hwA+Bc9jdpmjwi9PAWXP7s+lkeePP2+n+4P98o=
=vuIM
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--

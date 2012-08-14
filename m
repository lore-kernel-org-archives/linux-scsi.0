From: Paul Menzel <paulepanter@users.sourceforge.net>
Subject: [PATCH] drivers/scsi/Kconfig: Remove reference to non-existent
 howtos
Date: Tue, 14 Aug 2012 12:39:43 +0200
Message-ID: <1344940783.4138.5.camel@mattotaupa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pYAnvfEuzSNGi2eWhDr2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:34550 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2HNKjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 06:39:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>


--=-pYAnvfEuzSNGi2eWhDr2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Paul Menzel <paulepanter@users.sourceforge.net>
Date: Tue, 14 Aug 2012 12:22:43 +0200

Searching for =C2=BBscsi=C2=AB at <http://www.tldp.org/HOWTO/html_single/> =
I only
found =C2=BBSCSI-2.4-HOWTO=C2=AB [1].

    The Linux 2.4 SCSI subsystem HOWTO

[1] http://www.tldp.org/HOWTO/html_single/SCSI-2.4-HOWTO/

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
 drivers/scsi/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 74bf1aa..d717116 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -74,10 +74,7 @@ config BLK_DEV_SD
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
 	  USB storage or the SCSI or parallel port version of
-	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
-	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>. This is NOT for SCSI
-	  CD-ROMs.
+	  the IOMEGA ZIP drive, say Y. This is NOT for SCSI CD-ROMs.
=20
 	  To compile this driver as a module, choose M here and read
 	  <file:Documentation/scsi/scsi.txt>.
--=20
1.7.10.4

--=-pYAnvfEuzSNGi2eWhDr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAqKu8ACgkQPX1aK2wOHVicMgCePvSlRGF0aiRPpU51T2M4nmWE
H5gAmwUktDyVcEjH7BqKxDYfpcsPAME6
=cApp
-----END PGP SIGNATURE-----

--=-pYAnvfEuzSNGi2eWhDr2--


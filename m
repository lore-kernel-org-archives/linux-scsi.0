From: Paul Menzel <paulepanter@users.sourceforge.net>
Subject: [PATCH 2/3] Documentation/scsi/scsi.txt: Clean up typography and
 fix grammar
Date: Tue, 14 Aug 2012 12:13:49 +0200
Message-ID: <1344939229.4138.2.camel@mattotaupa>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-yghiIjmqM2ctcvRWb228"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:34539 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab2HNKN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 06:13:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>


--=-yghiIjmqM2ctcvRWb228
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Paul Menzel <paulepanter@users.sourceforge.net>
Date: Tue, 14 Aug 2012 11:59:31 +0200

1. Consistently use SCSI und Linux.
2. Use two spaces between sentences.
3. Remove trailing white space.

Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
---
 Documentation/scsi/scsi.txt |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/scsi/scsi.txt b/Documentation/scsi/scsi.txt
index 45b9c25..56afe6c 100644
--- a/Documentation/scsi/scsi.txt
+++ b/Documentation/scsi/scsi.txt
@@ -9,33 +9,33 @@ http://web.archive.org/web/*/http://www.torque.net/scsi/S=
CSI-2.4-HOWTO
=20
 Notes on using modules in the SCSI subsystem
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-The scsi support in the linux kernel can be modularized in a number of=20
+The SCSI support in the Linux kernel can be modularized in a number of
 different ways depending upon the needs of the end user.  To understand
 your options, we should first define a few terms.
=20
-The scsi-core (also known as the "mid level") contains the core of scsi=
=20
-support.  Without it you can do nothing with any of the other scsi drivers=
.
-The scsi core support can be a module (scsi_mod.o), or it can be built int=
o
-the kernel. If the core is a module, it must be the first scsi module=20
-loaded, and if you unload the modules, it will have to be the last one=20
+The scsi-core (also known as the "mid level") contains the core of SCSI
+support.  Without it you can do nothing with any of the other SCSI drivers=
.
+The SCSI core support can be a module (scsi_mod.o), or it can be built int=
o
+the kernel. If the core is a module, it must be the first SCSI module
+loaded, and if you unload the modules, it will have to be the last one
 unloaded.  In practice the modprobe and rmmod commands (and "autoclean")
 will enforce the correct ordering of loading and unloading modules in
 the SCSI subsystem.
=20
-The individual upper and lower level drivers can be loaded in any order=
=20
-once the scsi core is present in the kernel (either compiled in or loaded
+The individual upper and lower level drivers can be loaded in any order
+once the SCSI core is present in the kernel (either compiled in or loaded
 as a module).  The disk driver (sd_mod.o), cdrom driver (sr_mod.o),
-tape driver ** (st.o) and scsi generics driver (sg.o) represent the upper=
=20
-level drivers to support the various assorted devices which can be=20
-controlled.  You can for example load the tape driver to use the tape driv=
e,=20
+tape driver ** (st.o) and SCSI generics driver (sg.o) represent the upper
+level drivers to support the various assorted devices which can be
+controlled.  You can for example load the tape driver to use the tape driv=
e,
 and then unload it once you have no further need for the driver (and relea=
se
 the associated memory).
=20
 The lower level drivers are the ones that support the individual cards tha=
t
-are supported for the hardware platform that you are running under. Those
-individual cards are often called Host Bus Adapters (HBAs). For example th=
e
-aic7xxx.o driver is used to control all recent SCSI controller cards from=
=20
-Adaptec. Almost all lower level drivers can be built either as modules or=
=20
+are supported for the hardware platform that you are running under.  Those
+individual cards are often called Host Bus Adapters (HBAs).  For example t=
he
+aic7xxx.o driver is used to control all recent SCSI controller cards from
+Adaptec.  Almost all lower level drivers can be built either as modules or
 built into the kernel.
=20
=20
--=20
1.7.10.4

--=-yghiIjmqM2ctcvRWb228
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAqJN0ACgkQPX1aK2wOHVgILgCeMFj8Vsmi1mzvMu8gGZ7YdMyx
2KMAn37vWKfJAMPHKzq7VLN1e3ktF+1K
=jo2Y
-----END PGP SIGNATURE-----

--=-yghiIjmqM2ctcvRWb228--


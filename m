From: Thomas Maguin <T.Maguin@web.de>
Subject: Plextor PowerRec for users
Date: Sun, 12 Feb 2006 16:13:17 +0100
Message-ID: <200602121613.27504.T.Maguin@web.de>
Reply-To: T.Maguin@web.de
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2561932.VlAsV8juVi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp05.web.de ([217.72.192.209]:19085 "EHLO smtp05.web.de")
	by vger.kernel.org with ESMTP id S1750786AbWBLPNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 10:13:08 -0500
Received: from [80.136.201.153] (helo=paris.troja)
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.105 #340)
	id 1F8IuR-0000n2-00
	for linux-scsi@vger.kernel.org; Sun, 12 Feb 2006 16:13:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart2561932.VlAsV8juVi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Please add the following entries to allow :
command opcodes for PoweRec, VariRec (0xED & 0xEB)
and further settings opcodes  0xE9 on Plextor devices
as normal user.

/usr/src/linux/scsi/scsi.h
+#define PLEXTOR_MODE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00x39
+#define PLEXTOR_PREC_SPEEDS =C2=A0 0x3B
+#define PLEXTOR_MODE2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00x3D

/usr/src/linux/block/scsi/scsi_ioctl.c
+safe_for_read(PLEXTOR_MODE)
+safe_for_read(PLEXTOR_PREC_SPEEDS)
+safe_for_read(PLEXTOR_MODE2)



Thomas Maguin

--nextPart2561932.VlAsV8juVi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD71CXyat6ziqpM7YRAre4AJ9YWU/cf+kWCtjE9eOzdHlvuW4vGACgg23h
/nda1rh4Uq82xUdLyUMg41Q=
=uk2C
-----END PGP SIGNATURE-----

--nextPart2561932.VlAsV8juVi--

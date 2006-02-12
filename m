From: Thomas Maguin <T.Maguin@web.de>
Subject: Re: Plextor PowerRec for users
Date: Sun, 12 Feb 2006 17:18:04 +0100
Message-ID: <200602121718.15200.T.Maguin@web.de>
Reply-To: T.Maguin@web.de
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14077520.jboWO5tcvt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp08.web.de ([217.72.192.226]:25580 "EHLO smtp08.web.de")
	by vger.kernel.org with ESMTP id S1750806AbWBLQSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 11:18:00 -0500
Received: from [80.136.201.153] (helo=paris.troja)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.105 #340)
	id 1F8JvD-0001Zw-00
	for linux-scsi@vger.kernel.org; Sun, 12 Feb 2006 17:17:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart14077520.jboWO5tcvt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Blame on me, a typo in the addresses. Changes should be this:
(patch is on the way)

/usr/src/linux/include/scsi/scsi.h
+#define PLEXTOR_MODE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A00xe9
+#define PLEXTOR_PREC_SPEEDS =C2=A0 0xeB
+#define PLEXTOR_MODE2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A00xeD

/usr/src/linux/block/scsi/scsi_ioctl.c
+safe_for_read(PLEXTOR_MODE)
+safe_for_read(PLEXTOR_PREC_SPEEDS)
+safe_for_read(PLEXTOR_MODE2)




--nextPart14077520.jboWO5tcvt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD71/Hyat6ziqpM7YRAkZIAJ4wB+PBVOVurUWT2OapnwF2R1S8hgCgzO85
898IYO58c68lRL+kjpaC/j8=
=Y10I
-----END PGP SIGNATURE-----

--nextPart14077520.jboWO5tcvt--

From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][5/15] qlogicfas: use qlogicfas_name instead qinfo
Date: Tue, 9 Mar 2004 10:36:19 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133619.GG651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="umrsQkkrw7viUWFs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:7182 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261943AbUCIOGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:06:25 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id BEFB93285B
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:06:29 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 3F5DC236C1
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:28:03 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hP9-0000w3-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:36:19 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--umrsQkkrw7viUWFs
Content-Type: multipart/mixed; boundary="BFVE2HhgxTpCzM8t"
Content-Disposition: inline


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="05-qlogicfas-use_qlogicfas_name_instead_qinfo.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:41:20.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:41:30.000000000=
 -0300
@@ -667,7 +667,7 @@
 	sprintf(qinfo,
 		"Qlogicfas Driver version 0.46, chip %02X at %03X, IRQ %d, TPdma:%d",
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
-	host->name =3D qinfo;
+	host->name =3D qlogicfas_name;
=20
 	return hreg;
=20

--BFVE2HhgxTpCzM8t--

--umrsQkkrw7viUWFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATchTRRJOudsVYbMRAtWaAKCFEN+T+TI+w1bB8AczCfd28sKNUACghN6t
yTl8VQR76mDDuUjI4ADxh9Y=
=h0oN
-----END PGP SIGNATURE-----

--umrsQkkrw7viUWFs--

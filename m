From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][8/15] qlogic_cs: don't release region
Date: Tue, 9 Mar 2004 10:39:06 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133905.GJ651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1GSL5ZULXUIqbbH1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:6154 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261935AbUCINoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:44:04 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id D0CCC32844
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:43:53 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 55A582308A
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:30:50 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hRq-0000wS-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:39:06 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--1GSL5ZULXUIqbbH1
Content-Type: multipart/mixed; boundary="WZLuFERxa6Y0cbOt"
Content-Disposition: inline


--WZLuFERxa6Y0cbOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--WZLuFERxa6Y0cbOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="08-qlogic_cs-dont_release_region.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:39:=
09.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:45:10.=
000000000 -0300
@@ -240,9 +240,6 @@
 		outb(0x04, link->io.BasePort1 + 0xd);
 	}
=20
-	/* A bad hack... */
-	release_region(link->io.BasePort1, link->io.NumPorts1);
-
 	/* The KXL-810AN has a bigger IO port window */
 	if (link->io.NumPorts1 =3D=3D 32)
 		qlogicfas_preset(link->io.BasePort1 + 16, link->irq.AssignedIRQ);

--WZLuFERxa6Y0cbOt--

--1GSL5ZULXUIqbbH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcj5RRJOudsVYbMRAhA5AJ4ivhpORW2IlPK/fpfI9JHHwDRc6wCgqi5e
gc6lx7m0FGMhSxMKa3lSRPA=
=Nm0K
-----END PGP SIGNATURE-----

--1GSL5ZULXUIqbbH1--

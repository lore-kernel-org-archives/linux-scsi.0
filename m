From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][15/15] qlogic_cs: use own MODULE_ macros
Date: Tue, 9 Mar 2004 10:44:25 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309134425.GQ651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QXAv++6zoyBcX2gv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:7694 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261949AbUCIOGZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 09:06:25 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id A310532857
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 11:06:29 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 14A44236C8
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:36:10 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hWz-0000xL-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:44:25 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--QXAv++6zoyBcX2gv
Content-Type: multipart/mixed; boundary="ZvvH1QDaOFG4lOZN"
Content-Disposition: inline


--ZvvH1QDaOFG4lOZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--ZvvH1QDaOFG4lOZN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="15-qlogic_cs-use_own_module_macros.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-08 21:12:=
56.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-09 10:15:07.=
000000000 -0300
@@ -433,5 +433,8 @@
 		qlogic_detach(dev_list);
 }
=20
+MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
+MODULE_DESCRIPTION("Driver for the PCMCIA Qlogic FAS SCSI controllers");
+MODULE_LICENSE("GPL");
 module_init(init_qlogic_cs);
 module_exit(exit_qlogic_cs);
diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/driv=
ers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-09 10:13:25.000000=
000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-09 10:16:03.000000000=
 -0300
@@ -721,10 +721,6 @@
 	return priv->qinfo;
 }
=20
-MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
-MODULE_DESCRIPTION("Driver for the Qlogic FAS SCSI controllers");
-MODULE_LICENSE("GPL");
-
 /*
  *	The driver template is also needed for PCMCIA
  */
@@ -765,6 +761,9 @@
 		qlogicfas_release(priv->shost);
 }
=20
+MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
+MODULE_DESCRIPTION("Driver for the Qlogic FAS SCSI controllers");
+MODULE_LICENSE("GPL");
 module_init(qlogicfas_init);
 module_exit(qlogicfas_exit);
 #endif	/* ifndef PCMCIA */

--ZvvH1QDaOFG4lOZN--

--QXAv++6zoyBcX2gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATco5RRJOudsVYbMRAlzrAJ9Ir51sIBNNJE2D4NTFIbDrhGfbQACgnrY0
kImeDG6YIMK/u9KMAH24N8o=
=Ep5/
-----END PGP SIGNATURE-----

--QXAv++6zoyBcX2gv--

From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][9/15] qlogic_cs: use scsi_host_put
Date: Tue, 9 Mar 2004 10:39:45 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133945.GK651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZEZlOQeSr/zV9d3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:6410 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261929AbUCINoC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:44:02 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 348B632808
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:44:16 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 7EB8C236C4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:31:29 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hST-0000wZ-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:39:45 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--VZEZlOQeSr/zV9d3
Content-Type: multipart/mixed; boundary="daC8KDjlMyCcZyAo"
Content-Disposition: inline


--daC8KDjlMyCcZyAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--daC8KDjlMyCcZyAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="09-qlogic_cs-use_scsi_put.patch"
Content-Transfer-Encoding: quoted-printable

diff -ur linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.3-=
work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.3-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:46:=
06.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-05 18:46:17.=
000000000 -0300
@@ -287,7 +287,7 @@
 	pcmcia_release_io(link->handle, &link->io);
 	pcmcia_release_irq(link->handle, &link->irq);
=20
-	scsi_unregister(info->host);
+	scsi_host_put(info->host);
=20
 	link->state &=3D ~DEV_CONFIG;
 }

--daC8KDjlMyCcZyAo--

--VZEZlOQeSr/zV9d3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATckgRRJOudsVYbMRAgiWAKC97dSykKjhdOUs8VfirdT4u9CaBwCgmx8h
0OZMqQt7+gAhtrMxfx4ejfo=
=nYXQ
-----END PGP SIGNATURE-----

--VZEZlOQeSr/zV9d3--

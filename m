From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][4/15] qlogicfas: force can_queue
Date: Tue, 9 Mar 2004 10:35:29 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133529.GF651@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yr/DzoowOgTDcSCF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:63753 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261936AbUCINob (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:44:31 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 03033327B4
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:40:40 -0300 (EST)
Received: from matthew (matthew.cathedral.com [215.50.66.94])
	by cathedrallabs.org (Postfix) with ESMTP id 32BD8236C0
	for <linux-scsi@vger.kernel.org>; Tue,  9 Mar 2004 10:27:14 -0300 (BRT)
Received: from aris by matthew with local (Exim 3.36 #1 (Debian))
	id 1B0hOM-0000vw-00
	for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2004 10:35:30 -0300
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--yr/DzoowOgTDcSCF
Content-Type: multipart/mixed; boundary="3U8TY7m7wOx7RL1F"
Content-Disposition: inline


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



--=20
aris


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="04-qlogicfas-force_can_queue.patch"

diff -ur linux-2.6.3-applied/drivers/scsi/qlogicfas.c linux-2.6.3-work/drivers/scsi/qlogicfas.c
--- linux-2.6.3-applied/drivers/scsi/qlogicfas.c	2004-03-05 18:40:31.000000000 -0300
+++ linux-2.6.3-work/drivers/scsi/qlogicfas.c	2004-03-05 18:40:41.000000000 -0300
@@ -791,7 +791,7 @@
 	.eh_device_reset_handler= qlogicfas_device_reset,
 	.eh_host_reset_handler	= qlogicfas_host_reset,
 	.bios_param		= qlogicfas_biosparam,
-	.can_queue		= 0,
+	.can_queue		= 1,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,

--3U8TY7m7wOx7RL1F--

--yr/DzoowOgTDcSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcghRRJOudsVYbMRAtOTAJ9S5vhyubOz+I9gOLgpCj52jXQv/ACgmArz
1Fnj2UxVszV4HgRhfWFnP2s=
=K9/i
-----END PGP SIGNATURE-----

--yr/DzoowOgTDcSCF--

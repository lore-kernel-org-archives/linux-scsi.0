From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] scsi log is unlikely
Date: Sun, 18 Apr 2004 20:36:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418183642.GB4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63143 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263926AbUDRTEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:04:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Optimization.

Tell the compiler that the SCSI LOG will not likely happen.

--- linux-2.6.5/drivers/scsi/scsi_logging.h.orig	2004-04-04 05:36:17.000000=
000 +0200
+++ linux-2.6.5/drivers/scsi/scsi_logging.h	2004-04-15 21:18:42.284491405 +=
0200
@@ -46,7 +46,7 @@ extern unsigned int scsi_logging_level;
=20
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)		\
 {								\
-        if ((SCSI_LOG_LEVEL(SHIFT, BITS)) > (LEVEL))		\
+        if (unlikely((SCSI_LOG_LEVEL(SHIFT, BITS)) > (LEVEL)))	\
 		(CMD);						\
 }
 #else
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAgsq6xmLh6hyYd04RAiiTAJ9Dq/8HmepAZZrt40j8AAbdyzsjXwCgqkvd
pU82oV1IMaaALae55l6i4JQ=
=gDxp
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--

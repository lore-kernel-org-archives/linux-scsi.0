From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: PATCH: usb-storage: fix typo
Date: Sun, 19 Jan 2003 17:16:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030119171602.D31114@one-eyed-alien.net>
References: <20030119143058.A31114@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030119143058.A31114@one-eyed-alien.net>; from mdharm-usb@one-eyed-alien.net on Sun, Jan 19, 2003 at 02:30:58PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch goes on top of the last one.  It fixes a typo in the test for
scsi_register() failure.

Please apply.

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.667   -> 1.668 =20
#	drivers/usb/storage/usb.c	1.68    -> 1.69  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/01/19	mdharm@zen.san.one-eyed-alien.net	1.668
# Fix a typo -- reversed the logic of failure test for scsi_register()
# --------------------------------------------
#
diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c	Sun Jan 19 17:15:18 2003
+++ b/drivers/usb/storage/usb.c	Sun Jan 19 17:15:18 2003
@@ -912,7 +912,7 @@
=20
 	/* now register	*/
 	ss->host =3D scsi_register(&usb_stor_host_template, sizeof(ss));
-	if (ss->host) {
+	if (!ss->host) {
 		printk(KERN_WARNING USB_STORAGE
 			"Unable to register the scsi host\n");
=20
--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--3Pql8miugIZX0722
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+K03RIjReC7bSPZARAuZkAJ0cXEpT9Xg3QV1JUP9lx0bsPZQW4gCgo0l+
7z7kvBeIjOtbNWSysH/qBxQ=
=w817
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--

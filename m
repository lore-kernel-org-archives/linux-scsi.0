From: Kurt Garloff <garloff@suse.de>
Subject: IBM 4000R needs LARGELUN
Date: Tue, 13 Aug 2002 20:49:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020813184948.GF17417@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Dave Jones <davej@suse.de>, Marcelo Tosatti <marcelo@conectiva.com.br>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Hubert Mantel <mantel@suse.de>, Manoj Naik <manoj@almaden.ibm.com>


--Sw7tCqrGA+HQ0/zt
Content-Type: multipart/mixed; boundary="SnV5plBeK2Ge1I9g"
Content-Disposition: inline


--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

another device to be added to the black list with BLIST_SPARSELUN |
BLIST_LARGELUN. I got his one from Manoj Naik.

Patch attached.

PS: I'm afraid the number of devices that reports SCSI-2 and needs SPARSELU=
N |
LARGELUN will increase rapidly in the future and maybe it's a good idea to
offer people the possibility to enable those two flags with a module/boot
parameter llun_blklst=3DC,B,T[,C,B,T[,...]] as implemented in the patch
http://www.suse.de/~garloff/linux/scsi-many/scsi-largelun-param-2-2419S1.di=
ff

Another option would be to rework the scanning code to not need those two
flags, but I've been told that this is not actually intended for 2.4.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--SnV5plBeK2Ge1I9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ibm4000r-largelun-2419.diff"
Content-Transfer-Encoding: quoted-printable

--- linux/drivers/scsi/scsi_scan.c.orig	Fri Aug  2 18:00:01 2002
+++ linux/drivers/scsi/scsi_scan.c	Tue Aug 13 20:40:08 2002
@@ -181,6 +181,7 @@
 	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
+	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
=20
 	/*
 	 * Must be at end of list...

--SnV5plBeK2Ge1I9g--

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9WVTMxmLh6hyYd04RApKrAKC4jwhv4S8D13dWzkQDY3C/t5OEeQCdGNf6
rXUFeVkdH5NZoCUTlEF3Wpc=
=ZqEy
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--

From: Kurt Garloff <garloff@suse.de>
Subject: [PATCH] Additional BLIST_LARGELUN devices
Date: Wed, 26 Jun 2002 18:47:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020626164744.GH3023@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>, Dave Jones <davej@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--pMCBjikF2xGw87uL
Content-Type: multipart/mixed; boundary="PWfwoUCx3AFJRUBq"
Content-Disposition: inline


--PWfwoUCx3AFJRUBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcello, Dave,

here are some additional devices that need the BLIST_LARGELUN flag.
When I sent the patch to implement the flag, I only knew about the EMC
Symmetrix. Some more have turned up ...
The ones here have been collected from EMC, RH, SuSE sources.

Please consider inclusion into the next 2.4.19 RC.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--PWfwoUCx3AFJRUBq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="50_scsi-largelun-2.4.19-pre7aa1"
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.4.18.tmp/drivers/scsi/scsi_scan.c linux-2.4.18.SuSE/drive=
rs/scsi/scsi_scan.c
--- linux-2.4.18.tmp/drivers/scsi/scsi_scan.c	Wed Apr 24 11:26:44 2002
+++ linux-2.4.18.SuSE/drivers/scsi/scsi_scan.c	Wed Apr 24 11:35:48 2002
@@ -149,17 +149,17 @@
  	{"TOSHIBA","CDROM","*", BLIST_ISROM},
  	{"TOSHIBA","CD-ROM","*", BLIST_ISROM},
 	{"MegaRAID", "LD", "*", BLIST_FORCELUN},
-	{"DGC",  "RAID",      "*", BLIST_SPARSELUN}, // Dell PV 650F (tgt @ LUN 0)
-	{"DGC",  "DISK",      "*", BLIST_SPARSELUN}, // Dell PV 650F (no tgt @ LU=
N 0)=20
-	{"DELL", "PV660F",   "*", BLIST_SPARSELUN},
-	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN},
-	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN}, // Dell PV 530F
-	{"DELL", "PV530F",    "*", BLIST_SPARSELUN}, // Dell PV 530F
+	{"DGC",  "RAID",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
650F (tgt @ LUN 0)
+	{"DGC",  "DISK",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
650F (no tgt @ LUN 0)=20
+	{"DELL", "PV660F",   "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // =
Dell PV 530F
+	{"DELL", "PV530F",    "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
530F
 	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCEL=
UN},
 	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP VA7400, b=
y Alar Aun
-	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN},   // CMD RAID Controller
-	{"CNSI", "G7324", "*", BLIST_SPARSELUN},     // Chaparral G7324 RAID
-	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
+	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD RAID=
 Controller
+	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparra=
l G7324 RAID
+	{"CNSi", "G8324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparra=
l G8324 RAID
 	{"Zzyzx", "RocketStor 500S", "*", BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", "*", BLIST_SPARSELUN},
 	{"SONY", "TSL",       "*", BLIST_FORCELUN},  // DDS3 & DDS4 autoloaders

--PWfwoUCx3AFJRUBq--

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9GfAvxmLh6hyYd04RArCPAKDGShFMc87iA3pYPxE/MwCTX6vPNgCfYYv8
wRSE4L6ZHCDkR5i9dj9nG5I=
=8oED
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--

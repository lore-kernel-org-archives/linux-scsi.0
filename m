From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Additional BLIST_LARGELUN devices
Date: Thu, 27 Jun 2002 23:28:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020627212808.GB14392@gum01m.etpnet.phys.tue.nl>
References: <20020627145301.GB11237@gum01m.etpnet.phys.tue.nl> <Pine.LNX.4.44.0206271721270.11790-100000@freak.distro.conectiva>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0206271721270.11790-100000@freak.distro.conectiva>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Michael Clark <michael@metaparadigm.com>, Dave Jones <davej@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>


--uxuisgdDHaNETlh8
Content-Type: multipart/mixed; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcelo,

On Thu, Jun 27, 2002 at 05:22:14PM -0300, Marcelo Tosatti wrote:
> On Thu, 27 Jun 2002, Kurt Garloff wrote:
> > OK, it got in that list by accident then. Won't hurt, of course.
> > I removed the flag. New patch attached.
>=20
> Could you please send me a patch to remove that one list entry because I
> already applied the previous one.

Attached.
Thanks for applying the other patch!

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2419rc1-larglun-devs-fix1.diff"

diff -uNr linux-2.4.18.S18.fixed/drivers/scsi/scsi_scan.c linux-2.4.18.S18.fixed.fixlargelun/drivers/scsi/scsi_scan.c
--- linux-2.4.18.S18.fixed/drivers/scsi/scsi_scan.c	Wed Jun 12 11:37:13 2002
+++ linux-2.4.18.S18.fixed.fixlargelun/drivers/scsi/scsi_scan.c	Thu Jun 27 23:25:13 2002
@@ -161,7 +161,7 @@
 	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP VA7400, by Alar Aun
 	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD RAID Controller
 	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparral G7324 RAID
-	{"CNSi", "G8324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparral G8324 RAID
+	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
 	{"Zzyzx", "RocketStor 500S", "*", BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", "*", BLIST_SPARSELUN},
 	{"SONY", "TSL",       "*", BLIST_FORCELUN},  // DDS3 & DDS4 autoloaders

--vOmOzSkFvhd7u8Ms--

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9G4NnxmLh6hyYd04RAlZpAJ9qdaA7voqMpcg1l3cW57IO1bJq0wCfXt/J
QkpPxE04qan0KOWQC4G2VBo=
=m8PD
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--

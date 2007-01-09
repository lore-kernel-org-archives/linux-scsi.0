From: Kurt Garloff <kurt@garloff.de>
Subject: [PATCH] scsi_scan message cosmetic error
Date: Tue, 9 Jan 2007 02:28:54 +0100
Message-ID: <20070109012854.GV18689@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wiiWofWi8Et/oezL"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750897AbXAIB27@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--wiiWofWi8Et/oezL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Minor typo ...=20
In my first iteration of patches (that got merged), the
BLIST_ATTACH_PQ3 actually had the value 0x800000, but that
got changed later to avoid conflicts. This piece must have
been overlooked.
You could obviously do something like %x and then add the
bitflags, but that looks overkill for something that does
not tend to change.

Please merge.
(Patch applied against latest 2.6.20rc version that I tested.)

=46rom: Kurt Garloff <kurt@garloff.de>
Subject: [SCSI SCAN] Fix logging message for PQ3 devices

The blacklist flags BLIST_ATTACH_PQ3 has value 0x1000000,
not 0x800000.

Signed-off-by: Kurt Garloff <garloff@suse.de>

Index: linux-2.6.16-SLES10_SP1_BRANCH/drivers/scsi/scsi_scan.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.16-SLES10_SP1_BRANCH.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.16-SLES10_SP1_BRANCH/drivers/scsi/scsi_scan.c
@@ -941,9 +941,9 @@ static int scsi_probe_and_add_lun(struct
 				unsigned char mod[17];
=20
 				sdev_printk(KERN_INFO, sdev,
 					"scsi scan: consider passing scsi_mod."
-					"dev_flags=3D%s:%s:0x240 or 0x800240\n",
+					"dev_flags=3D%s:%s:0x240 or 0x1000240\n",
 					scsi_inq_str(vend, result, 8, 16),
 					scsi_inq_str(mod, result, 16, 32));
 			});
 		}
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: Head Architect          <garloff@suse.de>            [Novell Inc]

--wiiWofWi8Et/oezL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFou/WxmLh6hyYd04RAkFyAJ4mj7urdLMTdnKy/RM2jGmUhmmEiwCgpJEM
T64BmEAaiE6RtUKmWlJwbj0=
=it/J
-----END PGP SIGNATURE-----

--wiiWofWi8Et/oezL--

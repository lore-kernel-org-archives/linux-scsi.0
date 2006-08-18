From: Joshua Rubin <joshua@rubixlinux.org>
Subject: Bug#380272: kernel-image-2.6-686-smp: cpqarray module fails to detect arrays
Date: Fri, 18 Aug 2006 09:59:16 -0600
Message-ID: <200608180959.16889.joshua@rubixlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1336052.gtkZYnBrxK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 70-89-161-115-Joshua-Rubin-co.hfc.comcastbusiness.net ([70.89.161.115]:51334
	"EHLO smokescreen.cybertron.cc") by vger.kernel.org with ESMTP
	id S1161040AbWHRQAM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 12:00:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 380272@bugs.debian.org
Cc: maximilian attems <maks@sternwelten.at>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

--nextPart1336052.gtkZYnBrxK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Maks,

I have confirmed that loading cpqarray first fixes the problem on several=20
systems now. I have also realized that when this is the case, the sym53c8xx=
=20
driver is not needed or loaded. I thought this was noteworthy. It appears=20
that your presumption was correct that the sym53c8xx and cpqarray modules d=
o=20
not play nicely.

Is this something that can be handled in the initramfs automatically instea=
d=20
of forcing everyone running these systems to update=20
their /etc/initramfs-tools/modules file?

Thanks again!!!
Joshua

--nextPart1336052.gtkZYnBrxK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBE5ePUkKWMTL7MAq4RAszpAJwIC5ocelI6JZKbRAjQ5ToUphRR8ACdGMsv
WaE/apgbPTRrRTGOqGrY5R8=
=zOLL
-----END PGP SIGNATURE-----

--nextPart1336052.gtkZYnBrxK--

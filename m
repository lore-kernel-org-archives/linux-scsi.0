From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Wed, 23 Feb 2005 12:44:48 +0100
Message-ID: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-samJLUfOik7wY9CNUXzp"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:57740 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S261467AbVBWLpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 06:45:00 -0500
Received: from ilfb02.ilsb.tuwien.ac.at (ilfb02.ilsb.tuwien.ac.at [128.130.71.3])
	by gh-gw1.ilsb.tuwien.ac.at (8.12.3/8.12.3/Debian-7.1) with ESMTP id j1NBimBI031076
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 12:44:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-samJLUfOik7wY9CNUXzp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Kernel: 2.6.10-rc4 w/ 3 tape patches from Kai Makisara

SCSI: 53C1030 controller, tape drive is on one channel of the
controller.

Tape: Overland Changer w/ Seagate LTO-1 drive
Typical transfer speed: 12MB/s

After adding a Megaraid Zero Channel Raid Controller to that
computer the transfer speed of the tape changed to 2.6 MB/s

Disks on the other channel of the 53C1030 are NOT affected
(disk performance OK).

stinit.def has NOT been changed.

No error messages.
I didn't find any changable parameters for the Megaraid adapter
for TAPE drives.

What did I do wrong? How to provide you with additional data?

Thank you in advance!
                                  Gerhard Schneider

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-samJLUfOik7wY9CNUXzp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCHGywE6e53f4wQG4RAtXvAKCGb07nWHV8BnW0gqM4Zn8PWP2D0wCdHdof
xE0Gr0kTeeThrRKbAH0Fhls=
=Vrml
-----END PGP SIGNATURE-----

--=-samJLUfOik7wY9CNUXzp--


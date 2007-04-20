From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: mpt: sync offset errors?
Date: Fri, 20 Apr 2007 09:57:01 +0200
Message-ID: <4628724D.5060507@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig75CAEEBF1FA76A710C893094"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw2.ilsb.tuwien.ac.at ([128.130.23.15]:48764 "EHLO
	gh-gw2.ilsb.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992723AbXDTJKr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2007 05:10:47 -0400
Received: from [128.130.71.82] (gs.ilsb.tuwien.ac.at [128.130.71.82])
	by gh-gw2.ilsb.tuwien.ac.at (8.13.8/8.13.8/Debian-3) with ESMTP id l3K7v4E2009638
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2007 09:57:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75CAEEBF1FA76A710C893094
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


System: linux-2.6.21rc3

3 53c1030

2 times 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI
        version: 08

1 time version: 07

After adding another disk array I'm getting some

kernel: mptbase: ioc1: LogInfo(0x11040000): F/W: SYNC Offset Error
        mptbase: ioc4: LogInfo(0x11040000): F/W: SYNC Offset Error

(both are the new disk cage)

But the system seems to be working as expected (performance o.k.)

What could be the reason of that? Should I be afraid?

                               Gerhard Schneider
--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/


--------------enig75CAEEBF1FA76A710C893094
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGKHJQE6e53f4wQG4RAqHeAKCqcQz8awEf1pvMRzisQKEgiqBZCwCdEWhI
7bFQX6f0XO/z/INN9PcTrK4=
=Nm6I
-----END PGP SIGNATURE-----

--------------enig75CAEEBF1FA76A710C893094--

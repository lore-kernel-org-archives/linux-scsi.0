From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 11:42:53 +0100
Message-ID: <43D604AD.6050607@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDDAE9EDE64AD17232D4F54B2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:18835 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1030441AbWAXKnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 05:43:02 -0500
Received: from [128.130.71.3] (ilfb02.ilsb.tuwien.ac.at [128.130.71.3])
	by gh-gw1.ilsb.tuwien.ac.at (8.13.3/8.13.3/Debian-6) with ESMTP id k0OAgxd5028981
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 11:42:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDDAE9EDE64AD17232D4F54B2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


It's getting me mad..

It seems that with 2.6 (compared to 2.4) there has something been
changed in the kernel that I'm not aware of so I'm not able to
write/read tapes efficiently anymore..

LSI1030 SCSI controller
Overland tape library
Seagate LTO-1 tape drive

Kernel 2.4.29:

dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
776+1 records in
776+1 records out
50918460 bytes transferred in 4.620612 seconds (11019852 bytes/sec)

Kernel 2.6.14rc1:

dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
776+1 records in
776+1 records out
50918460 bytes transferred in 20.395567 seconds (2496545 bytes/sec)

Another machine w/
LSI1030 SCSI controller
Megaraid ZCR controller
Overland tape library
HP LTO-3 tape drive
Kernel 2.6.14rc1:

dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
776+1 records in
776+1 records out
50918460 bytes transferred in 45.953133 seconds (1108052 bytes/sec)

Either there is an initialization problems with tape drives on 2.6.*
(I don't think so) or there are tunable kernel parameters that
I don't know..

CPU load on 2.6 is minimal, tape is waiting for data..

Any idea? (I can provide you with any amount of data etc..)

                                            GS

-- 
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/

--------------enigDDAE9EDE64AD17232D4F54B2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD1gSxE6e53f4wQG4RArgJAKD3T1HlVQPL21Dw7l5yUkTjQdMsMACg8VDP
9AiXRlys6+nC0OuemNh/YGk=
=WE5i
-----END PGP SIGNATURE-----

--------------enigDDAE9EDE64AD17232D4F54B2--

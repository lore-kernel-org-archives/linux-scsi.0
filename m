From: Steve McIntyre <steve@einval.com>
Subject: Qlogic ISP1020 in 2.6?
Date: Sun, 12 Dec 2004 00:33:58 +0000
Message-ID: <20041212003334.GC2420@einval.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5p8PegU4iirBW1oA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:27082 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S262041AbULLAeC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Dec 2004 19:34:02 -0500
Received: from sledge.mossbank.org.uk ([10.13.0.5] ident=Debian-exim)
	by mail.einval.com with esmtp (Exim 3.35 #1 (Debian))
	id 1CdHgU-0004MM-00
	for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2004 00:33:58 +0000
Received: from steve by sledge.mossbank.org.uk with local (Exim 4.34)
	id 1CdHgU-0001l3-4I
	for linux-scsi@vger.kernel.org; Sun, 12 Dec 2004 00:33:58 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--5p8PegU4iirBW1oA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've got an Alpha (COMPAQ Professional Workstation XP1000) with a
built-in ISP1020. Kernel 2.4.28 runs fine on this system; 2.6.9 gives
me the following errors:

ERROR: SCSI host `isp1020' has no error handling
ERROR: This is not a safe way to run your SCSI host
ERROR: The error handling must be added to this driver
fffffc0007fafdb8 0000000000000001 fffffc00011a5ac0 fffffc000158bcd0=20
       fffffc000158bcd0 fffffc0000366800 fffffc000158bcd0
	   fffffc0000366800=20
       fffffc0000000000 fffffc0007fafe00 fffffc0007fafe00
	   fffffc0000366800=20
       fffffc00011b0007 fffffc000158bcd0 fffffc00011b247c
	   fffffc000158bcd0=20
       0000000000000000 0000000000000000 fffffc00012fca88
	   fffffc000158bcd0=20
       0000000000000000 fffffc000158bdb0 fffffc00012fbf00
	   fffffc000126bf00=20
Trace:
[<fffffc00011a5ac0>] scsi_register+0x20/0xa0
[<fffffc00011b0007>] sdev_show_model+0x27/0x40
[<fffffc00011b247c>] isp1020_detect+0x8c/0x300
[<fffffc0001010168>] init+0x48/0x180
[<fffffc0001013018>] kernel_thread+0x28/0x90

qlogicisp : new isp1020 revision ID (6)
qlogicisp: mbox_command loop timeout #2
qlogicisp: mbox_command loop timeout #2
qlogicisp: mbox_command loop timeout #2
qlogicisp: mbox_command loop timeout #2

Googling for this has shown a fair number of other people with similar
problems, but I've not found any mention of somebody working on
this. I'm happy to take a look myself, but I thought it might be
useful to check here first before I wade in. Anybody?

--=20
Steve McIntyre, Cambridge, UK.                                steve@einval.=
com
"C++ ate my sanity" -- Jon Rabone

--5p8PegU4iirBW1oA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBu5H2fDt5cIjHwfcRAkMTAJ4pUC+za5DSvTQA401et5tshv597gCfai+j
MiVZFbp95yoV6YqQYTuVEBo=
=sYFO
-----END PGP SIGNATURE-----

--5p8PegU4iirBW1oA--


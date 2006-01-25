From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Wed, 25 Jan 2006 20:03:41 +0100
Message-ID: <43D7CB8D.80300@ilsb.tuwien.ac.at>
References: <43D604AD.6050607@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain> <Pine.LNX.4.63.0601242251190.6350@kai.makisara.local> <43D69590.5050003@ilsb.tuwien.ac.at> <Pine.LNX.4.64.0601251107480.5181@localhost.localdomain> <43D7A691.1040606@cococafe.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig79150904FD08F340A34BCD06"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:12761 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S1750703AbWAYTDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 14:03:50 -0500
Received: from [128.131.224.84] (v224-084.vpm.tuwien.ac.at [128.131.224.84])
	by gh-gw1.ilsb.tuwien.ac.at (8.13.3/8.13.3/Debian-6) with ESMTP id k0PJ3jtW003922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2006 20:03:46 +0100
In-Reply-To: <43D7A691.1040606@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79150904FD08F340A34BCD06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Denny Page schrieb:
> I agree.  In my case, the problem is also initial negation: 3 MB/s :-(.=

>=20
> Denny
>=20

Could be, as I wrote earlier I don't know how to check this on a
Fusion or Megaraid chipset because all I have is
/sys/class/scsi_tape/nst0/device/scsi_level=3D4
                                /queue_depth=3D7
                                /queue_type=3Dsimple

The 53c8xx drivers are more verbose..

Actually I'm running a full backup (a few TB) on a generic 2.6.11.12
kernel with good performance (>30MB/s) on the LTO-3 tape library on
a 53c1030 controller. That's first priority. After that backup I will
play again with different kernel versions and the other tape library.

Sorry for that delay..

                                             GS
--=20
Gerhard Schneider
Institute of Lightweight Design and         e-Mail: gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)                 Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria      Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29     http://www.ilsb.tuwien.ac.at/~gs/



--------------enig79150904FD08F340A34BCD06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFD18uRE6e53f4wQG4RAhLFAJ4r8UsnhWDnpCvMtM63BVNk0vgBvQCfbS2p
ULkBo0l/tlunkxZnIdc9ieA=
=s7Yn
-----END PGP SIGNATURE-----

--------------enig79150904FD08F340A34BCD06--

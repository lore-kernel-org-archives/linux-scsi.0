From: Nicolas Mailhot <Nicolas.Mailhot@one2team.com>
Subject: Adaptec scsi probe failure
Date: Thu, 23 Oct 2003 18:25:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066926316.20919.6.camel@ulysse.olympe.o2t>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7w7rv2kVQWkAkG581Yeu"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.clb.oleane.net ([213.56.31.19]:14811 "EHLO
	smtp3.clb.oleane.net") by vger.kernel.org with ESMTP
	id S263620AbTJWQZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 12:25:19 -0400
Received: from smtp.olympe.o2t (cerbere.one2team.com [194.206.159.179])
	by smtp3.clb.oleane.net with ESMTP id h9NGPITa028160
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2003 18:25:18 +0200
Received: from ulysse.olympe.o2t (ulysse.olympe.o2t [192.168.1.40])
	by smtp.olympe.o2t (Postfix) with ESMTP id B9EB21CB4D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2003 18:25:17 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ulysse.olympe.o2t (Postfix) with ESMTP id 77C81A88E7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2003 18:25:17 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-7w7rv2kVQWkAkG581Yeu
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

I'm currently investigating a problem at a remote site when a new tape
drive failed being detected by the system. According to the customer the
tape drive does appear in the scsi bios messages. The problem is - dmesg
shows the system thinks nothing is plugged on the scsi channel (nothing
shows in the device enumeration that usually follows chipset detection)

System is RH 7.3 (latest official kernel), hardware Compaq ML 350G3 +
internal ultrium 460.

The on-motherboard scsi chipset is adaptec-based.

What could cause this ? I'd understand communication problems, but not
showing up at all is way too strange. Any ideas ?

Cheers,

--=20
Nicolas Mailhot
One2team : 12 bis rue de la Pierre lev=E9e - 75011 Paris - France =20
T=E9l : + 33 1 43 38 19 80 - Fax : +33 1 43 14 23 07

--=-7w7rv2kVQWkAkG581Yeu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/mADrmsj7VFSyrYsRAu8VAKCXXLzWYlBD+ySUcVDgSqhM/B0EIACgmlLH
gJx6F6/GXERYdcXtNw2rV2E=
=k7MU
-----END PGP SIGNATURE-----

--=-7w7rv2kVQWkAkG581Yeu--


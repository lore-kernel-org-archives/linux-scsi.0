From: Ming Zhang <mingz@ele.uri.edu>
Subject: code path
Date: Thu, 09 Jun 2005 08:50:55 -0400
Message-ID: <1118321455.5511.27.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lyQDwyx0hi5BpQxQtmOw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:54923 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262222AbVFIMu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 08:50:59 -0400
Received: from localhost.localdomain (leviathan [131.128.51.64])
	by leviathan.ele.uri.edu (8.12.9/8.12.9) with ESMTP id j59Cot9e010529
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 08:50:56 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


--=-lyQDwyx0hi5BpQxQtmOw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I wonder if anybody could tell me the kernel code path for these two
commands?

echo "scsi remove-single-device 0 0 4 0" > /proc/scsi/scsi
echo "scsi add-single-device 0 0 5 0" > /proc/scsi/scsi


I have a SATA controller that whenever I execute these 2 command to system,=
=20
it has problem. I assume this is because the card driver.


Thanks


Ming


--=-lyQDwyx0hi5BpQxQtmOw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCqDsvSYbkL5BnVYoRAsKZAJ42JgF8amUpOoGIF21yKwus9j7XmQCffBtO
1iywOfFqQunzZLT8Ov+7NxI=
=VtrH
-----END PGP SIGNATURE-----

--=-lyQDwyx0hi5BpQxQtmOw--


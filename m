From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: bus:id:lun to device name
Date: 02 Jul 2003 17:24:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057159447.825.68.camel@lt-sv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vbipc56iZBtK5Y9SBhsH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pong.to.com ([194.221.251.36]:50949 "EHLO pong.to.com")
	by vger.kernel.org with ESMTP id S265037AbTGBPJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2003 11:09:55 -0400
Received: from pong.to.com (localhost.localdomain [127.0.0.1])
	by localhost.pong.to.com (Postfix) with ESMTP id B8809E6A5A
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2003 17:24:19 +0200 (CEST)
Received: from to.com (fw-dmz.to.com [194.221.251.46])
	by pong.to.com (Postfix) with ESMTP id 988D18B2E2
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2003 17:24:19 +0200 (CEST)
Received: from localhost (elwood.think [192.168.10.15])
	by to.com (Postfix) with ESMTP id 5FE89C0460
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2003 17:24:19 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-vbipc56iZBtK5Y9SBhsH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I want to convert a bus:id:lun triple to something like "/dev/sda".

=46rom userspace I can ioctl() /dev/s[d|cd|...]* or parse /proc/scsi/scsi.
I do not like any of those solutions.

Since a kernel module is already involved, I was wondering if it
can/may/should be done from kernelspace. As of 2.4.21 some data
structures from the middle layer are exported, but with a "debug only"
comment.

regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-vbipc56iZBtK5Y9SBhsH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/AvkXtWF28C4HGsQRArPyAKCFd8RsXx47j3OP01C0lvAJGAYgBQCeIX79
Y2oBWXHPB4kzucMdCV7XDCw=
=Kr+c
-----END PGP SIGNATURE-----

--=-vbipc56iZBtK5Y9SBhsH--


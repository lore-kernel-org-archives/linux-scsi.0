From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH 2.4 0/2] Fix cpqfc
Date: Mon, 2 Jan 2006 12:44:34 +0100
Message-ID: <200601021244.40636@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7527062.oBKsEja3Yq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:42655 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750724AbWABMGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2006 07:06:52 -0500
Received: from mp-pc92.informatik.uni-mannheim.de ([::ffff:134.155.64.118]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 02 Jan 2006 13:06:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>

--nextPart7527062.oBKsEja3Yq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

As there are still people out there trying their luck with the ancient cpqf=
c=20
driver that is in 2.4 kernel I think we should make this a bit less buggy.=
=20
The next 2 patches don't change the driver behavior but reduce stack usage=
=20
and make sure not to copy foreign stack memory.

Eike

--nextPart7527062.oBKsEja3Yq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDuRIoXKSJPmm5/E4RAtPyAKCBuqlS2S82H07xeOJFKb2ioGGOSACgk1vT
a5O10Ry+bZ6xFS0Xqt0+jXs=
=tOTz
-----END PGP SIGNATURE-----

--nextPart7527062.oBKsEja3Yq--

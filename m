From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Usb storage mounting was broken somewhere between 2.6.0-test5-bk10
	and 2.6.0-test6-bk1
Date: Wed, 22 Oct 2003 00:33:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BhvmmvruS0i1h4v8Qnw1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nan-smtp-01.noos.net ([212.198.2.70]:46418 "EHLO smtp.noos.fr")
	by vger.kernel.org with ESMTP id S263311AbTJUWdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2003 18:33:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


--=-BhvmmvruS0i1h4v8Qnw1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

	I'd like to bring to your attention bug #1310 :

http://bugzilla.kernel.org/show_bug.cgi?id=3D1310

Short summary (full info in the bugzilla page) :

1. my usb storage device stopped working (mounting) after
2.6.0-test5-bk10=20

2. the usb storage maintainer says nothing changed at the usb level, so
it's probably the scsi layer that broke somehow

3. I won't test kernel snapshots between 2.6.0-test5-bk10 and
2.6.0-test6-bk1 since they also had a raid bug and I spent days
recovering from it (which is why I didn't push bug #1310 as I should
have - I took a kernel testing break afterwards)
=20
I've just retested with 2.6.0-test8-bk1 and the bug is still there.

More patch tests, logs, etc available on demand (though the bugzilla
entry is already pretty complete)

Cheers,

--=20
Nicolas Mailhot

--=-BhvmmvruS0i1h4v8Qnw1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/lbQ/I2bVKDsp8g0RAhSfAJ43rpDAvMBfNhL/nVKybebrPzoNEACdG6Hv
KWGnDhrsE7NLI0XUS7Rv2B8=
=9QuE
-----END PGP SIGNATURE-----

--=-BhvmmvruS0i1h4v8Qnw1--


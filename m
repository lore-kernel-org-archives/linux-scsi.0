From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Re: Usb storage mounting was broken
Date: Thu, 23 Oct 2003 21:59:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066939156.2773.3.camel@m70.net81-64-235.noos.fr>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
	 <20031021175556.A8670@beaverton.ibm.com>
	 <1066808944.3699.9.camel@ulysse.olympe.o2t> <3F969E04.6060801@pacbell.net>
	 <1066837537.6960.3.camel@ulysse.olympe.o2t> <3F96AE64.5020305@pacbell.net>
	 <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>
	 <3F96D00E.1080500@pacbell.net>
	 <1066854786.3848.8.camel@m70.net81-64-235.noos.fr>
	 <3F970A51.3060907@pacbell.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RNT5qg2laIZzCG9pvTE3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nan-smtp-10.noos.net ([212.198.2.81]:37937 "EHLO smtp.noos.fr")
	by vger.kernel.org with ESMTP id S261740AbTJWT7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 15:59:19 -0400
In-Reply-To: <3F970A51.3060907@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


--=-RNT5qg2laIZzCG9pvTE3
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le jeu 23/10/2003 =E0 00:53, David Brownell a =E9crit :
> >>And since this resembles an enumeration failure, it'd be good
> >>to have the Alt-Sysrq-t output for "khubd".
> >=20
> > In the report too (took me some time to remember it ended up in
> > /var/log/messages, not only the current console)
>=20
> That says to me "self-deadlock"; crept in recently.  It turns
> out that routine already has all the locks it needs.  Try the
> attached patch.
>=20
> This is pretty far from being a mount problem ... no wonder I
> kept expecting more info from you!

This patch sucessfully unlocks device detection and mount now works,
thanks ! However it seems another bug crept in usb-storage since a cp
from the SM card stalls forever (directories are created, so is the
first file but its size stays 0).

I'll open a new bug. (third in a row:()

Cheers,

--=20
Nicolas Mailhot

--=-RNT5qg2laIZzCG9pvTE3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/mDMTI2bVKDsp8g0RAjk7AKDoESFhCncpubnceuVYOxk3yZpz/QCgntZj
/00w1CiWveMZQcBeyXXliPA=
=EPEi
-----END PGP SIGNATURE-----

--=-RNT5qg2laIZzCG9pvTE3--


From: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Subject: Re: Usb storage mounting was broken somewhere
	between	2.6.0-test5-bk10 and 2.6.0-test6-bk1
Date: Wed, 22 Oct 2003 17:45:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066837537.6960.3.camel@ulysse.olympe.o2t>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>
	 <20031021175556.A8670@beaverton.ibm.com>
	 <1066808944.3699.9.camel@ulysse.olympe.o2t>  <3F969E04.6060801@pacbell.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wzDxuH3LcS6B+zqICETn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.clb.oleane.net ([213.56.31.18]:14213 "EHLO
	smtp2.clb.oleane.net") by vger.kernel.org with ESMTP
	id S263467AbTJVPq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 11:46:28 -0400
In-Reply-To: <3F969E04.6060801@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


--=-wzDxuH3LcS6B+zqICETn
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mer 22/10/2003 =E0 17:11, David Brownell a =E9crit :
> > Well, I tried to provide all the data:(.
>=20
> Not in your updates of last night you didn't ...
>=20
> You've omitted any data that would identify a problem.
> In fact there's no evidence you even connected such a
> device to the test6 kernel.
>=20
> So I closed that bug report.  If you come up with any
> evidence to support a real bug report, file a new bug
> report with it.  But having this one sitting around
> in such a state does nobody any good.

Rhaa. There is no evidence of a failure. The reader is plugged like in
previous kernels, logs show it's detected as a usb-storage device, then
*nothing*.

I can't give you any error because no error is outputed. If I could make
up an error message believe me I would .

Cheers,

--=20
Nicolas Mailhot

--=-wzDxuH3LcS6B+zqICETn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/lqYgI2bVKDsp8g0RAvHlAKDODAt3TewJy3sgbReLFGnIvHmBVACdFM4R
oDE2Yake8exF9zULObqbPMw=
=GXrH
-----END PGP SIGNATURE-----

--=-wzDxuH3LcS6B+zqICETn--


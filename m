From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: 2.6.0-test4-mm5: SCSI imm driver doesn't compile
Date: Thu, 4 Sep 2003 15:52:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030904135256.GS14376@lug-owl.de>
References: <20030902231812.03fae13f.akpm@osdl.org> <20030903170256.GA18025@fs.tum.de> <20030904133056.GA2411@conectiva.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVXm2WAry1WzRMtx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dvmwest.gt.owl.de ([62.52.24.140]:58260 "EHLO dvmwest.gt.owl.de")
	by vger.kernel.org with ESMTP id S265008AbTIDNw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2003 09:52:57 -0400
Content-Disposition: inline
In-Reply-To: <20030904133056.GA2411@conectiva.com.br>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@conectiva.com.br>, Adrian Bunk <bunk@fs.tum.de>, Andrew Morton <akpm@osdl.org>, campbell@torque.net


--BVXm2WAry1WzRMtx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-09-04 10:30:56 -0300, Arnaldo Carvalho de Melo <acme@conectiva=
=2Ecom.br>
wrote in message <20030904133056.GA2411@conectiva.com.br>:
> Em Wed, Sep 03, 2003 at 07:02:56PM +0200, Adrian Bunk escreveu:
> > The following compile error (tested with gcc 2.95) seems to come from=
=20
> > Linus' tree:
>=20
> I just converted it to the more safe c99 init style, but haven't noticed

C99 style is

	.element =3D initializer,

not
	[element] =3D initializer,

which is a GNU/GCCism.

MfG, JBG

--=20
   Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481
   "Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur | Gegen Krieg
    fuer einen Freien Staat voll Freier B=FCrger" | im Internet! |   im Ira=
k!
      ret =3D do_actions((curr | FREE_SPEECH) & ~(IRAQ_WAR_2 | DRM | TCPA));

--BVXm2WAry1WzRMtx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/V0O3Hb1edYOZ4bsRAhniAJ9WvjYXTmW/CnpeYmM56QaBpIB7uQCdEfaD
n2vukuXYqQ9fSGtn6iNYPIQ=
=xp44
-----END PGP SIGNATURE-----

--BVXm2WAry1WzRMtx--

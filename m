From: Paul Blazejowski <paulb@blazebox.homeip.net>
Subject: Re: Linux [2.6.0-test3/mm1] aic7xxx problems.
Date: Tue, 12 Aug 2003 14:56:16 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1060714576.849.3.camel@blaze.homeip.net>
References: <1060543928.887.19.camel@blaze.homeip.net>
	 <2425882704.1060622541@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TBefMCLAjaqHbg9WZXz5"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <2425882704.1060622541@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-TBefMCLAjaqHbg9WZXz5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-08-11 at 13:22, Justin T. Gibbs wrote:

>=20
> I don't think that any of the changes between 6.2.35 and 6.2.36 will
> make a difference for you, but you could try upgrading.  The source
> files are here:
>=20
> http://people.FreeBSD.org/~gibbs/linux/SRC/
>=20
> The console output you've provided makes me think that interrupts are
> not working correctly in your system.
>=20
> --
> Justin
>=20
>=20

Justin,

I have a nice oops from the
http://people.freebsd.org/~gibbs/linux/SRC/aic79xx-linux-2.5-20030603-tar.g=
z driver on 2.6.0-test3.

I took few snaps which show the scsi controller scan process and the
oops from kernel, they are at:
http://www.blazebox.homeip.net:81/diffie/images/linux-2.6.0-test2/2.6.36/

Paul

--=-TBefMCLAjaqHbg9WZXz5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/OThPIymMQsXoRDARAmtHAJ0a6Gh56EYg1/7xyzoSKvXJscGAGACeIXEX
ZgrrGU73qaeiTWKy/JMJ0pw=
=ymEt
-----END PGP SIGNATURE-----

--=-TBefMCLAjaqHbg9WZXz5--

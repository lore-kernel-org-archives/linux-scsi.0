From: Dumitru Ciobarcianu <Dumitru.Ciobarcianu@iNES.RO>
Subject: Bug#239952: Binary-only firmware covered by the GPL?
Date: Fri, 26 Mar 2004 11:43:28 +0200
Message-ID: <1080294208.27237.2.camel@LNX.iNES.RO>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de>
	 <20040325082949.GA3376@gondor.apana.org.au>
	 <20040325220803.GZ16746@fs.tum.de>  <40635DD9.8090809@pobox.com>
	 <1080260235.3643.103.camel@imladris.demon.co.uk>
	 <4063EEC1.9080203@stesmi.com>
Reply-To: Dumitru Ciobarcianu <Dumitru.Ciobarcianu@iNES.RO>,
	239952@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EZXwy1whWHkLAIMXbdLa"
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.239952.B239952.108029421425962@bugs.debian.org>
In-Reply-To: <4063EEC1.9080203@stesmi.com>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: Stefan Smietanowski <stesmi@stesmi.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@fs.tum.de>, 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-EZXwy1whWHkLAIMXbdLa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-03-26 at 09:50 +0100, Stefan Smietanowski wrote:
> /*
>      This file is under the GPL, yada yada
> */
> #include "things.h"
>=20
> void some_func(void)
> {
>    does_something();
> }
>=20
> char firmware[]=3D{0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
>=20
> void upload_firmware(void)
> {
>    do_upload(firmware);
> }
>=20
> --
>=20
> Then it seems clear to me that the firmware is under the GPL because it
> is PART of the GPL'd file.


If you're right, then the "binary" of the firmware it's GPL, not the
source of the firmware, because that's what you have in this case :)

You can have that ? GPL the binary but not the source ? :)

--=20
Cioby

--=-EZXwy1whWHkLAIMXbdLa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAY/s/QisRnSkd59cRAufwAJsHNzMld0DucqhRxASL1csizPySDQCeIwFz
8IB2cyzJ6DcHpUZ7ZHc4Ky0=
=b0qO
-----END PGP SIGNATURE-----

--=-EZXwy1whWHkLAIMXbdLa--

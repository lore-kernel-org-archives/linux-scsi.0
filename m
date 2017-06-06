From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: next build: 113 warnings 0 failures (next/next-20170605)
Date: Wed, 7 Jun 2017 00:36:22 +0200
Message-ID: <20170606223621.GA3628@katana>
References: <59351e18.c490630a.4dca5.e785@mx.google.com>
 <CAK8P3a1D0r9XAfGN95EkiaXvCmkJq1Em=xggJw87yX7YH7o-vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a1D0r9XAfGN95EkiaXvCmkJq1Em=xggJw87yX7YH7o-vA@mail.gmail.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof's autobuilder <build@lixom.net>, Olof Johansson <olof@lixom.net>, Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, Joe Carnuccio <joe.carnuccio@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Wolfram Sang <wsa+renesas@sang-engineering.com>, Jean Delvare <jdelvare@suse.de>, linux-i2c@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >       2 drivers/i2c/i2c-stub.c:18:0: warning: "DEBUG" redefined
>=20
> Caused by 6c42778780c4 ("i2c: stub: use pr_fmt"): "#define DEBUG"
> now conflicts with "ccflags-$(CONFIG_I2C_DEBUG_CORE) :=3D -DDEBUG"
> in the Makefile.

I'll fix it tomorrow!


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlk3LmEACgkQFA3kzBSg
KbYLYBAAp2AylYFmxGreevx1fRKIiDneRMoyjsn2AoeokOgIfwUi6PuvQNOe1hnh
mQM3hYefNlvJKvrWzfn2aCT+IcjznM3m+rb+w9LmnXyb0BUfB8SWYznctvYjDrnj
yX1B6PkYZs1BTUzljwGPpoaTzL28FiazQn0joD879afFVLxQGApy32mewYtDo6qG
/pUCQRfBS6M34ixsDdDW1crP6GHa0O7OAFflOHDy6ayFHIOGmkY1p74vdUVJNVAc
SAiK8vtj1pSD1vSK1jXrzDEgBBWg+t4RBffSYn1H2VJ6N+oz0ROguVuJp04Ess1F
7x7DxHsiqA5tuYFxcTEYTC8lhxicVJKtiHSH35MKSkSnE13rAKdIFFux065AMEhy
Xb2NZ77yK9mnejr/syKl6vQnOQeVermwcU2wykrOSE2vpLTaflWC5p66USETmqxR
V56EiHFVHsuuTaobGwqw5qRFtiQO++7VcqqM4TYrYXisBERi837CqlTWNgB9uFE/
7EVOl73Q5AVZWUtljW/uXl9r08JaLJDvEwg2jrNewQ1CLis8+gKhOUOUkZuNLY0C
S5hrmFXFj7a5AVyeus9Fwndpn/GGXRd6B2r9fxR+gevJCN4ofbYtLo71Go/EDf4s
r15M8Cn0DlY05fEJyWM4mCg7wYfQqgJTPIuVMXRp4+C/4QDTHW8=
=AR0e
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

From: Chris Cheney <ccheney@cheney.cx>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 16:54:23 -0600
Message-ID: <20040325225423.GT9248@cheney.cx>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de> <20040325082949.GA3376@gondor.apana.org.au> <20040325220803.GZ16746@fs.tum.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bxF9Dep5HzwGj9mC"
Return-path: <bounce-debian-devel=debian-devel=m.gmane.org@lists.debian.org>
Content-Disposition: inline
In-Reply-To: <20040325220803.GZ16746@fs.tum.de>
Resent-Message-ID: <_C1pnC.A.kWG.RN2YAB@murphy>
List-Post: <mailto:debian-devel@lists.debian.org>
List-Help: <mailto:debian-devel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-devel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-devel-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-devel/>
To: debian-devel@lists.debian.org
Cc: Adrian Bunk <bunk@fs.tum.de>, 239952@bugs.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--bxF9Dep5HzwGj9mC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 25, 2004 at 11:08:03PM +0100, Adrian Bunk wrote:
> There's another issue with these files:
>=20
<--  snip  -->
>=20
> The GPL says that you must give someone receiving a binary the source=20
> code, and it says:
>   The source code for a work means the preferred form of the work for
>   making modifications to it.
>=20
>=20
> This is perhaps a bit besides the main firmware discussion and IANAL,=20
> but is this file really covered by the GPL?

IMHO code that can be compiled would probably be the preferred form
of the work. The source to the firmware in many cases and probably even
this one is very unlikely to be able to be compiled under Linux at all.
Also, unless the driver is written by the company producing the hardware
itself even the author will likely not have the source code to the
firmware and will only have a binary form (think reverse engineering).
IMHO a driver for a piece of hardware does not include the software that
the hardware itself is running, just the software that the primary CPU
itself is running. YMMV.

Chris

--bxF9Dep5HzwGj9mC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAY2Mf0QZas444SvIRAt/RAJ4wmdbSFqS0+T+bxYMBuPSHYvlAcACeJMJQ
oOO838b5qQG2dugQV2sEu28=
=BTod
-----END PGP SIGNATURE-----

--bxF9Dep5HzwGj9mC--

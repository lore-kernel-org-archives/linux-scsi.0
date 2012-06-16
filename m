From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Sat, 16 Jun 2012 14:40:34 +0100
Message-ID: <1339854034.4942.176.camel@deadeye.wl.decadent.org.uk>
References: <87obojef7t.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5RP20bYKhAY3Kf2bgWW4"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87obojef7t.fsf@schwinge.name>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-5RP20bYKhAY3Kf2bgWW4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-06-16 at 12:14 +0200, Thomas Schwinge wrote:
> Hi!
>=20
> After many others that played with no problems, I just tried playing
> Guano Apes' audio CD =C2=BBProud Like a God=C2=AB (1997) in Rhythmbox, on=
 my mostly
> up-to-date Debian GNU/Linux testing system.
>=20
>     $ uname -a
>     Linux boole 3.2.0-2-amd64 #1 SMP Mon May 21 17:45:41 UTC 2012 x86_64 =
GNU/Linux
>=20
> ... which specifically is =C2=BBlinux-image-3.2.0-2-amd64 3.2.18-1=C2=AB.
>=20
> While "loading" the CD in Rhythmbox, after a few seconds the kernel
> crashed.  I rebooted, tried again, and it crashed again.  At
> <http://schwinge.homeip.net/~thomas/tmp/linux-crash-audio-cd.jpeg> you
> can find the panic message (low resolution, sorry), pointing to the
> SCSI/ATA code.
>=20
> Are there any such known issues?  Does the panic message give any clue
> already, or would you want me to reproduce that with debugging symbols,
> etc.?

Your computer is broken; Machine Check Exception indicates a hardware
fault.  The other text at the top of the screen may help to identify
which component is at fault.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camu=
s

--=-5RP20bYKhAY3Kf2bgWW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9yM0ue/yOyVhhEJAQq7cg//QSGRDjAvE2Ajo9srxS1VPIJ2mbVQjUft
HV5bnGvZl3DMq2XxPnDZgpY82C8IqrtiyRYlmaM4HasWlC0iBa82nYZkoTkAhKMH
hoKpy5R4x6eUEuCrTmfXisuuel/9I3ZmEB3Sq3WOVt/jxl714CS8voqj392Ykf/o
M6xe+QQTh6PoFGStPu6Owg/WN21NE+eRbzRAVqGswUe1x5QfFCLk3Nxm71sGebT+
6Pbm8lpug3cPgL6l9aIJkUK/CYO8ug7GU/EfiBJPOq/M4FT9gUNcljQVp80UJ8IY
9zPpuZCIbR97lXNEYKGrTq78wY4TFmJhinu8L2xdobwbTqkXCXl2COhRLlAf5/gL
BjdV4qwLTzOlTWivN9Wz5WhBobghqM5plHH/HTnwb23lw4S09+e6CEUhoLhh7rF4
w/2R03KsOXl0srg0SxET0KKsvgR3UV24tybswCDPwIf1wUvyjLEktx+g43cZJz5t
sgp8FObO3S0t2ceHpokElv9MnHGWz3bVvoUOJD8Cg50t/HjGAYx0LcaKeehEXip1
zS3M3l9eMP6y9epbanHnasXSV38e60eBUWbDgf/PksacqaMRa98qww9PACP5NomA
vqBdoHco4Oev2FdhRWWrFnf8RsL9IIbxN23D06thWL0LWx9qf4P5FKj+4SPaDQA5
EERE+qu3cdg=
=E2wF
-----END PGP SIGNATURE-----

--=-5RP20bYKhAY3Kf2bgWW4--

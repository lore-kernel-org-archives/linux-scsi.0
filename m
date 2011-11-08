From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Tue, 8 Nov 2011 19:49:39 +1100
Message-ID: <20111108194939.1ddff5af4c877850cfb9e1f9@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
	<CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Nov_2011_19_49_39_+1100_DxQyOnXa65BzQ2kh"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__8_Nov_2011_19_49_39_+1100_DxQyOnXa65BzQ2kh
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Nov 2011 08:07:37 +0100 Bart Van Assche <bvanassche@acm.org> wrot=
e:
>
> On Tue, Nov 8, 2011 at 1:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> > On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley <James.Bottomley@Han=
senPartnership.com> wrote:
> >>=C2=A0The true fix is to do a proper
> >> teardown instead of hand rolling it. =C2=A0Does this fix it for you?
> >
> > I don't get the WARNING any more, but now get lots of:
> >
> > scsi: killing requests for dead queue
>=20
> This patch should help: http://www.spinics.net/lists/linux-scsi/msg55373.=
html.

Thanks.  Will that be added to the scsi{,-rc-fixes} trees soon?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Nov_2011_19_49_39_+1100_DxQyOnXa65BzQ2kh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuO0jAAoJEECxmPOUX5FE72oP/RhYlr1uDZ1XdeDZOpHIyOkw
xgRJDVM1PmhSG/P5y7pEZRP1pu/fTS8mGAmsz4fnc97bOnbdShZ10tZ3+zNrPE64
zuQi1uN09f0QqfocR+CQrEbj+5cPES0mtKLQBVO+b4JA4fdXx9xHWTrD5pD0IG9o
kjwg91Zme+ocFNPy3zLFGeVC3h+qJNzD9hd1TGKY8txmRHolJnaLlWUZcRdvvWVD
+Krv9xLwKAsMghdi6MwsGbxLK4+sdz6q6OVhKeYOR7i1aT2hvJV3i+4CzfnLsVWz
3U9jZlA3QSwa/J2p6NxGTqLhkqLJ7uw2i/yRtzYvrkz7iVtw8PReD9B5O0Xdk1KC
xbWJR+vPIQObRUSj2+A0z5AkE7tXDIcJZKc0pZa0ZTxGQkpwlQHziSJieUEdEBXw
sxzAF9iNinJ2MaUc4862GrRXbBVIk+/OtQu1JAX92PBEkmAJMpEN/sHOIYkV1w8v
8A26DwmUMBhBKOBlfY7eD4yKYxp//gfZnhmDzBkbnXZvvB/yOvwWEmC4Tkrp4nsE
6MbENYZdYAOo7OPOmVIaQqUlLtB4aC/txnkfnGJB6z17R/ETrpnG2sHahVSqQ7Kn
4I6aAZudpEsig6irxoa7dlJYsFDcpFWq8bfBOeeyGPljxwo34AscV4s/LOzFJFy1
w2UVefxG4GdcF10OXA/Z
=XIBl
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Nov_2011_19_49_39_+1100_DxQyOnXa65BzQ2kh--

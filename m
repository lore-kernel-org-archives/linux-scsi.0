From: Christian Hesse <mail@eworm.de>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Mon, 23 Mar 2015 09:10:35 +0100
Message-ID: <20150323091035.53b2d73a@leda.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	<1426859486.19806.30.camel@localhost.localdomain>
	<20150320153104.086f3b46@leda.localdomain>
	<1426863883.19806.65.camel@localhost.localdomain>
	<20150320162441.684366b6@leda.localdomain>
	<1426866365.19806.81.camel@localhost.localdomain>
	<20150320185901.0283191c@leda.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RQVLpwOOnX=xxU7x9QFBJSv"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:60292 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbbCWIS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2015 04:18:58 -0400
In-Reply-To: <20150320185901.0283191c@leda.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

--Sig_/RQVLpwOOnX=xxU7x9QFBJSv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Christian Hesse <list@eworm.de> on Fri, 2015/03/20 18:59:
> Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 11:46:
> > On Fri, 2015-03-20 at 16:24 +0100, Christian Hesse wrote:
> > > I found 'max_sectors_kb' which is inside in directory called 'queue'.=
 Is
> > > that the value you asked for?
> > >=20
> > > for 4.0 git:
> > >=20
> > > # cat max_sectors_kb
> > > 32767
> >=20
> > If you change max_sectors_kb to a lower value (e.g. 512) can you get the
> > device to work?
>=20
> I will check that on monday. Sitting behind a slow dial up connection rig=
ht
> now...

No, it still fails the same way.

After the error it is back to a value of 32767. Is this because of a tried
reconnect?
--=20
Best regards,
Chris

--Sig_/RQVLpwOOnX=xxU7x9QFBJSv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVD8p7AAoJEFTtyRYJvJGDzegP/2w9P0K+mhRvNbgDHoGu0mNa
Iz1VdLnoH9SaK477GKzYIDwIZbsj6W2D6nqxtzQpd64wvc34wjBnJSFa40z0k1++
QPkf6JeClK1VOQnoXWtNRjioEcXoUUgZORNoel3CN95P3NzcMO+4NkVZ+t8FAeGn
99BPI6al2PL1DSFSkL5mvJ7p9MjfJ3fQFByy3Q7q/0VYhpi7VS4VbhM/tMaCpZTD
9aeWee/OUodHzNuOd1pbIdZK0Lo/VK5q+XV07y+F0eLy2BZ+5IibGfFk/E/MmY+s
dvuY8u4YqQWqSPl7odplXqVi/hhgcCNaBnuj3QHDCZRh/+k5MoUkeNX8ok7+K3Zb
cabx17+rF2P9pKnIfSuriJu9B+kYMF9DE8F41+TqxUL6CmDQi5mee4SkhYcKVCX1
rmof2WKJqOc7865D9ZDd4jtYPJ9swycXS9QtoVPgN5oyl/yodageeyO2PTo4nDCi
xSqJ1kwugFnTYa8tOa8zbc7VvCGid/iOlhVoKkiXU8f4Rk48ChWaNOuGCecskGOa
hor6V6wl3dT07dESIY4CPQx2uWHXyvboUOPqH1h3QZi1Ps792MsdVZeBijh0oeNb
ptXaXcOF215BnqFbChfriEjFJe4Tw22XkbAR4nmJ7e8lm9Cf3dfMIvzoyuiSRHAe
40W5beSdxXa6dG5Xif8g
=1nZE
-----END PGP SIGNATURE-----

--Sig_/RQVLpwOOnX=xxU7x9QFBJSv--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Questions about transfer lengths
Date: Sun, 15 Sep 2002 13:33:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020915133355.B21056@one-eyed-alien.net>
References: <20020913172656.B3611@one-eyed-alien.net> <Pine.LNX.4.33L2.0209151547190.11901-100000@netrider.rowland.org> <20020915130921.A21056@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020915130921.A21056@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Sun, Sep 15, 2002 at 01:09:21PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, usb-storage <usb-storage@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2002 at 01:09:21PM -0700, Matthew Dharm wrote:
> On Sun, Sep 15, 2002 at 03:57:50PM -0400, Alan Stern wrote:
> > On Fri, 13 Sep 2002, Matthew Dharm wrote:
> >=20
> > > > From what you're saying, it sounds like the ideal thing would be to=
 use
> > > > C :=3D D, but instead as a defense against buggy callers we actuall=
y should
> > > > try to set C :=3D min(A,D,E) if we can determine A, and C :=3D min(=
D,E)
> > > > otherwise.  In any case we should always check and report it as a b=
ug if
> > > > A !=3D D or D !=3D E.  Note that this is definitely _not_ what the =
code does
> > > > now.
> > >
> > > Um... we do check that C !=3D D or E -- we used to BUG_ON() if they w=
ere
> > > different, but Linus didn't like that.  Eventually, we will be removi=
ng the
> > > entire usb_stor_transfer_length() mess, tho.
> >=20
> > That's not quite true.  If we look at E at all (which we only do
> > sometimes), we only make sure that C =3D min(D,E).  And we don't log an
> > error message if D !=3D E.
>=20
> True enough.

Just to clarify this... in discussions on linux-scsi and with Linus, we
decided that D !=3D E is a bug and a caller problem.  No, we don't check for
it...=20

Again, the entire point is to try to get it so that we can trust all the
callers.  We're almost there -- any effort on this is best spent trying to
find any place where the caller is wrong and fixing it.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hO6zIjReC7bSPZARAmo3AKDQ6Q/OtdG//25FDfS1jsHZimKwNgCfVdal
BtTQzBr97z8D+uu822dMWcE=
=MGuu
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--

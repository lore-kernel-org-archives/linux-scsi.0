From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:12:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621171253.H2811@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <Pine.LNX.4.44.0306211706390.1980-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:7697 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264218AbTFUX6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 19:58:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0306211706390.1980-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Jun 21, 2003 at 05:07:48PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2003 at 05:07:48PM -0700, Linus Torvalds wrote:
> On Sat, 21 Jun 2003, Matthew Dharm wrote:
> >
> > This patch makes sr.c respect the use_10_for_ms flag.
>=20
> Ouch.
>=20
> Is there some SCSI person out there that would be willing to make sr.c=20
> look a bit more like sd.c in this respect? This is a bit hacky, I think,=
=20
> but I guess the sr.c layout forces that..

I actually think sd.c looks hacky in the way it handles this...

The other difference is that sd.c wants to issue MODE_SENSE in a couple of
places, where sr.c only wants to do it once.  So, creating an entirely
separate function to figure out what type of MODE_SENSE to send seems kinda
overkill to me.

I mean, this works, it's not difficult to follow, and meets all the
operational goals.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9PSFIjReC7bSPZARAl1EAKCjEbrTKwFK/Li5tzZo/qpcqQZGggCfbA/D
fpmSnxU074Sel8AJg0KrQvs=
=XHTs
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: usb storage traces
Date: Sat, 20 Dec 2003 15:56:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031220235651.GE8787@one-eyed-alien.net>
References: <20031219091450.GC828@one-eyed-alien.net> <Pine.LNX.4.44L0.0312190945170.805-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:27579 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261879AbTLTX5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2003 18:57:08 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312190945170.805-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, David Brownell <david-b@pacbell.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Looking at your traces, I don't see any MODE SENSE commands.  I find that
odd, especially since earlier traces show that data.

Looking at them, I'm starting to suspect that you need to have a valid
filesystem there before Windows will issue that command.  What an odd way
to do things....

Anyway, could you add that to your test cases?

The data you've provided so far is excellent.

Matt

On Fri, Dec 19, 2003 at 09:51:12AM -0500, Alan Stern wrote:
> On Fri, 19 Dec 2003, Matthew Dharm wrote:
>=20
> > On Fri, Dec 12, 2003 at 03:48:06PM -0700, Pat LaVarre wrote:
> > > > Also, I'm open to requests for particular host/device option
> > > > combinations.
> > >=20
> > > My wish list is:
> > >=20
> > > a) Device =3D x 08 (02|05|06) 50 =3D msft win generic usb-storage.
> >=20
> > Did anyone ever get a chance to capture this data?
> >=20
> > Matt
>=20
> Andries Brouwer has just created a web page to hold USB Mass Storage=20
> traces, and I have submitted the ones I've had time to collect so far. =
=20
> They include Pat LaVarre's wish list, but only for Windows ME -- other=20
> versions of Windows will have to wait until the New Year or after.
>=20
> The URL for my traces is:
>=20
> http://www.win.tue.nl/~aeb/linux/usb/traces/winme/
>=20
> Also present in that directory is a README.txt file, although it doesn't=
=20
> show up in the default directory listing.  You can retrieve it through
>=20
> http://www.win.tue.nl/~aeb/linux/usb/traces/winme/README.txt
>=20
> Alan Stern

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/5OHDIjReC7bSPZARAq3HAKDDmVG3ygir7dB/0A8AAQgb9pQWvgCguOAC
APkeoG4+UD6VdgZXjCq+bUE=
=ZhWy
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--

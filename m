From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: usb storage traces
Date: Thu, 4 Dec 2003 13:27:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204212749.GA4998@one-eyed-alien.net>
References: <20031204184428.GA17116@one-eyed-alien.net> <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:17792 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263591AbTLDV2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 16:28:09 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2003 at 03:59:58PM -0500, Alan Stern wrote:
> On Thu, 4 Dec 2003, Matthew Dharm wrote:
>=20
> > Did the device advertise 'generic scsi' or one of the other protocol co=
des?
> >=20
> > Microsoft has published information that indicates that they 'translate'
> > the mode-sense commands into the 10-byte variants for everything bug
> > 'transparent scsi' -- I think actually seeing that information would be
> > necessary in constructing a new algorithm for Linux.
>=20
> It was generic (transparent) scsi.
>=20
> Perhaps I'll try implementing some of the other protocol codes in FSG,
> maybe also the "removeable media" flag.  This would also require
> implementing the PREVENT-ALLOW-MEDIUM-REMOVAL, READ-FORMAT-CAPACITIES, and
> START-STOP, possibly also REZERO-UNIT, SEEK, READ(12), and WRITE(12).
>=20
> (1).  Am I missing anything important?

Based on the information I've seen, any one of the other protocol codes
will be fine -- you don't need to do all, just transparent SCSI and one
other.  Of course, all codes would be good for testing.

> (2).  Can I afford to leave out some of those?  The last four don't look=
=20
> very useful.

I agree about the last four.  I can't think of anything else that might be
good to test.

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

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/z6bVIjReC7bSPZARAjTiAJ4+zWtrY2NPeldWhYsKQfZiew7iUgCgvO7T
GksHUhc+7VMzb7Be7fx0Vfw=
=6rwT
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--

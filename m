From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:46:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621174613.L2811@one-eyed-alien.net>
References: <20030621173033.J2811@one-eyed-alien.net> <Pine.LNX.4.44.0306211735500.1980-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="tv2SIFopg1r47n4a"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:45329 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264932AbTFVAcK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:32:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0306211735500.1980-100000@home.transmeta.com>; from torvalds@transmeta.com on Sat, Jun 21, 2003 at 05:38:44PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--tv2SIFopg1r47n4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2003 at 05:38:44PM -0700, Linus Torvalds wrote:
> The basic idea stands, though: your code depends on global device state=
=20
> not to change between the creation of the command and the parsing of it.=
=20
> Which just isn't a good thing to do.
>=20
> sd.c gets all of these things right (including re-transmission etc),=20
> simply because of how it does things. Which is why I prefer the sd.c=20
> approach over the simplistic patch. sd.c just looks a lot more robust.
>=20
> (Maybe that one has bugs too, but they aren't immediately obvious).

Okay, I can buy this.  I don't suppose you have someone you can sign-up to
fix this mess?  I really want to get rid of all the mode-sense translation
code in usb-storage.

I'm just not qualified to put in what it's going to take to fix this.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Now payink attention, please.  This is mouse.  Click-click. Easy to=20
use, da? Now you try...
					-- Pitr to Miranda
User Friendly, 10/11/1998

--tv2SIFopg1r47n4a
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9PxVIjReC7bSPZARAsC1AJ93ZjcQyUtriyaS4PWoI++l5PDQfwCfQWfm
h3YtBhnSrW5+KJtE3LCezEU=
=Qr0K
-----END PGP SIGNATURE-----

--tv2SIFopg1r47n4a--

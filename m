From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 11:48:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030422114825.A31829@one-eyed-alien.net>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl> <20030421181755.A19118@one-eyed-alien.net> <1051021911.14880.25.camel@dhcp22.swansea.linux.org.uk> <20030422083621.B28101@one-eyed-alien.net> <1051023931.15160.36.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:51726 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263338AbTDVSg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 14:36:27 -0400
Content-Disposition: inline
In-Reply-To: <1051023931.15160.36.camel@dhcp22.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Tue, Apr 22, 2003 at 04:05:31PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andries.Brouwer@cwi.nl, James Bottomley <James.Bottomley@SteelEye.com>, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, Linus Torvalds <torvalds@transmeta.com>, usb-storage@one-eyed-alien.net


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 04:05:31PM +0100, Alan Cox wrote:
> On Maw, 2003-04-22 at 16:36, Matthew Dharm wrote:
> > I thought that the entire point was to have all this in a centralized p=
lace
> > for use by multiple LLDDs (or anyone else for that matter).  Which is t=
he
> > entire point of this discussion.
>=20
> Centralise it, but as a library function. Its up to host controllers to
> call the filter functions and indicate what they want fixing up.
> Centralised is good but nailing it directly into the midlayer reduces
> flexibility a lot

And that's exactly what my patch does.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Now payink attention, please.  This is mouse.  Click-click. Easy to=20
use, da? Now you try...
					-- Pitr to Miranda
User Friendly, 10/11/1998

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pY55IjReC7bSPZARAodhAJ99EmKMyj74leY5MR32zED+Lp27XwCdEttu
e1JGBOow1FWPz0QI8zK4M8o=
=svB9
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--

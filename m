From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Wed, 6 Feb 2008 13:05:11 -0800
Message-ID: <20080206210511.GA30466@one-eyed-alien.net>
References: <20080205175403.GA31714@one-eyed-alien.net> <Pine.LNX.4.44L0.0802061516110.5359-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:44140
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760746AbYBFVF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 16:05:58 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802061516110.5359-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2008 at 03:23:39PM -0500, Alan Stern wrote:
> On Tue, 5 Feb 2008, Matthew Dharm wrote:
>=20
> > Six of one and a half-dozen of the other.  All we're arguing over is the
> > definition of "correct behavior" here.  You want to change the API so t=
hat
> > overrun is acceptable and handled; I prefer calling it a Bad Thing(tm).
> >=20
> > We both agree that the code shouldn't run off the end of the s-g list.
> >=20
> > Since you've already committed to updating the patch, then we can do it
> > your way.  Just make sure it's very very clear in the comments.
>=20
> Okay, here's my version.  It makes some significant changes to the=20
> interface for usb_stor_access_xfer_buf() -- in particular, the context=20
> information is now stored in an opaque structure rather than in ad-hoc=20
> local variables.  All the callers are updated to use the new interface.

Maybe this is a crazy question, but...

Why is this not in the SCSI core?  It's hardly USB-specific, and I'm
willing to bet that there are other HCDs (at least spb2) which need to do
this sort of thing...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

YOU SEE!!?? It's like being born with only one nipple!
					-- Erwin
User Friendly, 10/19/1998

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHqiEHHL9iwnUZqnkRAl7GAJ0Qq1Lnn7HFLHQ2ZHDYsmJ++bnZxwCdEZdy
f2NetqubEo7kKPOFCZtnwo4=
=3OLw
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--

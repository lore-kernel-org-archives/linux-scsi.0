From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: Wed, 30 Jul 2003 12:10:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030730121036.B30339@one-eyed-alien.net>
References: <1059520994.2298.263.camel@mulgrave> <Pine.LNX.4.44L0.0307301008460.2868-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:53778 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S273301AbTG3TKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 15:10:49 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307301008460.2868-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Jul 30, 2003 at 10:09:23AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2003 at 10:09:23AM -0400, Alan Stern wrote:
> On 29 Jul 2003, James Bottomley wrote:
>=20
> > On Mon, 2003-07-28 at 10:10, Alan Stern wrote:
> > > Jens:
> > >=20
> > > This patch changes the scsi_mode_sense() routine to retry up to a tot=
al of=20
> > > 3 times if a command fails with a UNIT ATTENTION sense key value.
> > >=20
> > > Without this change, sr.c does not properly read the capabilities mod=
e=20
> > > page for a just-powered-up cdrom drive -- it gives up upon receiving =
a=20
> > > Device Reset Occurred code.
> > >=20
> > > The patch looks lengthy, but most of it just changes the indentation=
=20
> > > level.
> >=20
> > Actually, this isn't really the correct place for it.  The problem
> > occurs in sr not sd because sd already does an initial TUR to clear the
> > unit attention.
> >=20
> > Before OLS got in the way and I got submerged in writing presentations,
> > I had some patches that Matt Dharm was testing out to add the TUR to the
> > initial sr code.
> >=20
> > I'll pick that up (...er, when I get caught back up at work).
>=20
> Okay, that ought to take care of it just as well.

I had been wondering what ever happened to that... James, I presume you
still have my last set of data, regarding my CD-RW initialization?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Let me guess, you started on the 'net with AOL, right?
C:  WOW! d00d! U r leet!
					-- Greg and Customer=20
User Friendly, 2/12/1999

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/KBgsIjReC7bSPZARArAtAKCCR0gYInPW+AshWUL+rqzc2VGPLQCgtUkA
WS5jSLu3aZAUf6LrOfD2gbw=
=kmnf
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Wed, 26 May 2004 14:10:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526211039.GC29805@one-eyed-alien.net>
References: <1F6D1D1660975A4887628A011443A1BC0305E3CF@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:64489 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265804AbUEZVKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 17:10:50 -0400
Content-Disposition: inline
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC0305E3CF@uswaumsx13medge.med.ge.com>
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: linux-scsi@vger.kernel.org


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2004 at 03:24:49PM -0500, Edwards, Scott (MED, Kelly IT Res=
ouces) wrote:
>=20
> I know this is slightly off topic for this list, but I have been
> fighting with this for about a month now and I feel like I'm getting
> nowhere.  I tried the plscsi and scu utilities.  One of them I couldn't
> make heads or tails of.  The other one would read the "inquiry" command
> ok, but I couldn't figure out how to make it give me the output of the
> "IDENTIFY" command (0xEC).  This is what I really need to read.
>=20
> I have written (mostly copied from other stuff) a little program to just
> turn off the write cache.  (I have included the source below.)  But
> without being able to read the results of the identify I can't tell if
> it actually works or not.  I have tried writing a program myself that
> just sends the (0xEC) command, but all I get back is 70 00 05 00 00 00
> 00 06 00 00 00 00 20 00 00 00 which I'm guessing are the sense bytes?
> (Excuse my ignorance the last time I messed with this stuff it was
> called SASI instead of SCSI.)

Those do look like sense bytes.  I decode them to mean:
	Illegal Request: invalid command operation code

So it sounds to me like the device got your command, but didn't understand
it.

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

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAtQfPIjReC7bSPZARAvA0AJ9/l00q/K9N0ydTJZBHIbt6WlzVPwCgkVhZ
JSqXQMhudTeiGA0LzdlJuQo=
=4cd9
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--

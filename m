From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Sun, 6 Nov 2005 13:58:56 -0800
Message-ID: <20051106215856.GA28452@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:22961 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S932263AbVKFV7K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Nov 2005 16:59:10 -0500
Content-Disposition: inline
In-Reply-To: <1131238146.9430.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 05, 2005 at 06:49:05PM -0600, James Bottomley wrote:
> On Sat, 2005-11-05 at 15:55 -0800, Matthew Dharm wrote:
> > On Fri, Nov 04, 2005 at 02:49:55PM -0600, James Bottomley wrote:=20
> > > Can you just try it with a modern kernel and see if anything still
> > > breaks?
> >=20
> > I just realized this plan has a problem...
> >=20
> > The reported SCSI level of a device is mostly garbage, but not always.
> > I've seen 0, 1, 2, 3, and 0xff all reported.  HOWEVER, the reported val=
ue
> > seems independent of what devices have vendor-specific commands (and th=
us
> > need the CDB[1] not messed with).
> >=20
> > It is an interesting experiment to remove the force-to-SCSI_2 part of t=
he
> > usb-storage code (on the general principal of "we shouldn't be messing =
with
> > the data passed through the driver), but it doesn't solve the original
> > question of needing a way to pass commands without CDB[1] getting alter=
ed.
>=20
> Well, that might be a problem if it weren't for the fact that this
> LUN_INHIBIT flag was removed in 2002.  If it's taken three years to find
> a device that has a problem with it, I don't really think it's a
> particularly widespread problem.  And since the device that now shows
> the problem is setting the level to 0, it looks like we have a potential
> solution that fits all known cases.

Was it really removed that long ago?  I guess there are still a lot of
people using 2.4 kernels, then.

I've been recommending this flag to people as recently as 6 months ago
(i.e. the last time someone asked me).   It comes up 2-3 times a year.

The last time it came up, the device set SCSI_2.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDbnygHL9iwnUZqnkRAsDZAKCWxKRxiXzCkqhT8MYIgGSj1M31CACgiI8h
nzW+LvcTctS8JrJgm19hKvQ=
=OFgk
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--

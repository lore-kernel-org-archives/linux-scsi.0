From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 5 Apr 2003 16:20:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030405162055.D4320@one-eyed-alien.net>
References: <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030405112759.B4320@one-eyed-alien.net> <1049571946.2538.94.camel@mulgrave> <20030405115546.C4320@one-eyed-alien.net> <1049573311.1762.121.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:61446 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262734AbTDFAJg (for <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2003 19:09:36 -0500
Content-Disposition: inline
In-Reply-To: <1049573311.1762.121.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 05, 2003 at 02:08:29PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2003 at 02:08:29PM -0600, James Bottomley wrote:
> On Sat, 2003-04-05 at 13:55, Matthew Dharm wrote:
> >=20
> > My big complaint about that is that it's ugly.  I would like to keep the
> > device type as part of the filter command structure, so I can keep the =
call
> > to scsi_filter_cmd() simple and easy to maintain.  Maybe it's just me, =
but
> > I think that editing the filter table with an extra field will be easie=
r to
> > get right than trying to maintain several different filter tables (for =
each
> > device type).
>=20
> But that would reduce the power of the filter.  At the moment you can
> code "all devices apart from tapes" or "only disk and cdrom".  If I add
> it to the body of the filter, I either have to add a complex language to
> express this or reduce the power.  Neither seems to be particularly
> optimal

Okay, I'll buy that.

> > I guess the real power of this filter is in the ability to add logic to
> > scsi_filter_exceptions()... but centralizing that seems contrary to the
> > idea of doing this on a per-HBA basis.
>=20
> The filter is just a language.  HBAs don't need to use all the
> expressions in the exceptions, so unless it gets too big I don't see why
> necessary additions can't go centrally.

Eh.  I'm not really convinced on this point (based on my past history of
trying to get patches into the SCSI subsystem), but I think that situation
is improving, so I'll just let it go.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

God, root, what is difference?
					-- Pitr
User Friendly, 11/11/1999

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+j3LnIjReC7bSPZARAg7RAJ43ko0196t2Gyf5m0ESBnbX4s7fOgCgl0vn
eqB0G/ezQuRxLR2agJrpcgc=
=14lx
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--

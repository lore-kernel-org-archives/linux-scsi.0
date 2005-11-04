From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 12:30:34 -0800
Message-ID: <20051104203034.GG12384@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3A@WDSCEXBECL03.sc.wdc.com> <20051102234532.GC26148@one-eyed-alien.net> <1131077287.3117.22.camel@mulgrave> <20051104172844.GA12384@one-eyed-alien.net> <1131129230.3532.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yb+qhiCg54lqZFXW"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1131129230.3532.40.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Timothy Thelin <Timothy.Thelin@wdc.com>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--Yb+qhiCg54lqZFXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 12:33:50PM -0600, James Bottomley wrote:
> On Fri, 2005-11-04 at 09:28 -0800, Matthew Dharm wrote:
> > > I've no distinct recollection of someone removing this, but if I
> > > remember correctly what it used to do, it was a hack to stop us from
> > > mangling SCSI-3 CDB's.  We fixed the mid-layer not to require the hack
> > > by only setting the CDB[1] lun field for SCSI-1 and SCSI-2 devices (as
> > > the standards mandate).  What's the actual problem?  No SCSI-1 or SCS=
I-2
> > > device should have any vendor specific CDBs that uses these bits in
> > > CDB[1].
> >=20
> > Unfortunately, reality appears to disagree with the last "should".  I've
> > personally seen devices with vendor-specific commands that want to cont=
rol
> > CDB[1] in SCSI-2.
>=20
> > I didn't know it was removed; I only know what Timothy Thelin told me. =
 Can
> > we get the feature back?
>=20
> Not at all easily ... changes to support it would have to thread through
> several structures in both the block layer and the scsi subsystem.

Would the block layer really have to change much if the commands only come
from SG_IO?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

P:  How about "Web Designer"?
DP: I'd like a name that people won't laugh at.
					-- Pitr and Dust Puppy
User Friendly, 12/6/1997

--Yb+qhiCg54lqZFXW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDa8TqHL9iwnUZqnkRAqwjAJ0UptxXYcJU7fYy6LRxq8VWI+0gEACgpVnN
7r8C6uQQ1etc8yzziD1Jf7Q=
=FozH
-----END PGP SIGNATURE-----

--Yb+qhiCg54lqZFXW--

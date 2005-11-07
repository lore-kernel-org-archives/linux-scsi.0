From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security in usb-storage driver
Date: Mon, 7 Nov 2005 09:05:25 -0800
Message-ID: <20051107170525.GB26509@one-eyed-alien.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com> <1131130707.3532.45.camel@mulgrave> <20051104203004.GF12384@one-eyed-alien.net> <1131137395.3532.57.camel@mulgrave> <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave> <20051106215856.GA28452@one-eyed-alien.net> <436E8394.2010600@gmx.de> <20051106235213.GA479@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051106235213.GA479@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 06, 2005 at 03:52:13PM -0800, Patrick Mansfield wrote:
> On Sun, Nov 06, 2005 at 11:28:36PM +0100, thomas schorpp wrote:
> > >=20
> > >=20
> > > Was it really removed that long ago? =20
> >=20
> > yes
>=20
> Hmmm yeh, here is the original email with patch:
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D103470224812028&w=3D2

Okay, what am I missing?

Looking at that patch, it looks to me like if sg.c set a flag in the SCSI
command block then scsi_core.c could use that flag in the test to determine
if the LUN should be masked-in.

HOWEVER, I keep hearing that the changes will be extensive.  What am I
missing?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Oh great modem, why hast thou forsaken me?
					-- Dust Puppy
User Friendly, 3/2/1998

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDb4lVHL9iwnUZqnkRAvDcAKCbJn5GH5vFX+W4GOyEAuXIAtlGWQCgjdf4
tprJEPqyg85C7wjGgLpHQDA=
=9FYr
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--

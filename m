From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Help - sd vs. sg Devices, and Low-level Driver.
Date: Wed, 21 Apr 2004 13:18:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421201842.GA18090@one-eyed-alien.net>
References: <519672568F040C41B6FAC21ADF51B18FEFBA@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:31953 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263675AbUDUUSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 16:18:52 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFBA@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2004 at 11:12:38AM -0500, Lee Xing wrote:
> Thanks so much for the detail information.  It helps a lot!
>=20
> I didn't realize that both sg and sd will be attached to the same SCSI
> disk at the same time after boot.  However, I checked my system, "fdisk
> -l" and Hardware Browser->Hard Drives only show /dev/sda but not
> /dev/sg0.  How can we check /dev/sg0 is also attached to a SCSI disk?

The easiest way is probably to use lsscsi (on 2.6) or something from the
sg3_utils package.

> Besides 'mount' and 'dd', can normal SCSI passthrough ioctl calls
> (INQUIRY, READ/WRITE, RESERVE/RELEASE, MODE SELECT/SENSE, PERSISTENT
> RESERVATION, etc.) apply to both sd and sg devices?

To be honest, I don't know for certain.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I think the problem is there's a nut loose on your keyboard.
					-- Greg to Customer
User Friendly, 1/5/1999=20

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAhtciIjReC7bSPZARAvlxAJ9K+GfHvnK1OInSa8F5uAJ0FX1R/gCfeo8Y
U9lba9F0CLiaHhYCw+/y1Iw=
=KRBT
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: writable mmc profiles actually are writable
Date: Mon, 6 Oct 2003 23:45:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031006234543.A11937@one-eyed-alien.net>
References: <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2> <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:28680 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261802AbTJGGpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 02:45:50 -0400
Content-Disposition: inline
In-Reply-To: <20031007053858.GL972@suse.de>; from axboe@suse.de on Tue, Oct 07, 2003 at 07:38:58AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2003 at 07:38:58AM +0200, Jens Axboe wrote:
> On Mon, Oct 06 2003, Pat LaVarre wrote:
> > Yep, still happy, same in -test6 as in -test5 e.g.
> >=20
> > $ dmesg | grep ^sr
> > sr0: scsi3-mmc drive: 125x/125x caddy
> > sr0: scsi3-mmc maybe not writeable
> > sr0: scsi3-mmc writable profile: 0x0002
> > $
> > $ grep MMC /proc/sys/dev/cdrom/info
> > Can write other MMC-RW: 1 ...
>=20
> I don't quite agree with this patch. Please add the GET_CONFIGURATION
> stuff to cdrom.c instead so it works with ide-cd as well (ide-scsi is
> basically dead, and the number of scsi drives out there isn't exactly
> big and increasing). GPCMD_GET_CONFIGURATION already exists. Also, make
> DVD-RAM drives set CDC_MMC_RW as well and only check for that at open.

While the number of SCSI CD-ROM drives may be shrinking, the ATAPI drives
behind a USB/ATAPI bridge is skyrocketing.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Somebody call an exorcist!
					-- Dust Puppy
User Friendly, 5/16/1998

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/gmEXIjReC7bSPZARAhVaAJ4+wQUuyHGD3D4deVnrjOcHVwdu6gCeJX9O
cTh0S9vlkniYLQPEy9ao6yU=
=jeYA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

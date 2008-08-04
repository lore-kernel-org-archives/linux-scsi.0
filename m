From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Sun, 3 Aug 2008 19:18:22 -0700
Message-ID: <20080804021822.GI4322@one-eyed-alien.net>
References: <489656EC.5000602@torque.net> <1217813594.4179.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:43715
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYHDCS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 22:18:27 -0400
Content-Disposition: inline
In-Reply-To: <1217813594.4179.70.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dougg@torque.net, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 03, 2008 at 08:33:13PM -0500, James Bottomley wrote:
> On Mon, 2008-08-04 at 03:10 +0200, Douglas Gilbert wrote:
> > USB storage devices that support SAT (the T10 SCSI to ATA
> > translation standard) are beginning to appear.
>=20
> Um, confused.  The USB devices that were ATA under the covers already
> have to do SAT since the USB storage transport mandates SCSI.

The enclosures today translate a small subset set of SCSI commands to
ATA/ATAPI commands.

SAT would allow arbitrary ATA commands to be sent to target devices.  In
theory.  I've only seen a few products that support ATA passthrough, and
they all did it in a vendor-proprietary manner.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I could always suspend a few hundred accounts and watch what happens.
					-- Tanya
User Friendly, 7/31/1998

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIlmbuHL9iwnUZqnkRAvyoAKCmhQtNHEHnLLCT2vz1jn6gPB3kZgCgrAAQ
7kXBlA2Q11mzPGdJMpP0g7Q=
=huNJ
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

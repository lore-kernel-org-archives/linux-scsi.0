From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Help - sd vs. sg Devices, and Low-level Driver.
Date: Mon, 19 Apr 2004 17:06:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420000610.GH30664@one-eyed-alien.net>
References: <519672568F040C41B6FAC21ADF51B18FEFB2@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGu/vTNewDGZ7tmp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:18833 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261425AbUDTAGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 20:06:15 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFB2@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org


--MGu/vTNewDGZ7tmp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 19, 2004 at 06:39:53PM -0500, Lee Xing wrote:
> Hi,
>=20
> These are newbi questions on sd and sg devices and low-level SCSI driver.=
  Any information would be appreciated.
>=20
> Q1:
> When the low-level SCSI driver registers a physical disk, which parameter=
s (in scsi_device or some other structs?) decide this physical disk will be=
 registered/presented as a sd or sg device and how?  I presume the low-leve=
l driver makes the decision which type of device (sd or sg) the physical di=
sk is registered/presented as, but I can be wrong.
>=20

The device type code in the INQUIRY response is used to determine this.
The low-level driver doesn't have to do anything to make this happen.

Also, 'sg' can attach to any type of device _at_the_same_time_ as 'sd'.
'sg' is "generic", after all.

> Q2:
> >From low-level driver coding/maintenance point of view, which one is eas=
ier, registering/presenting a physical disk as a sd or sg device?

Like I said, it's a non-issue for a low-level driver.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Okay, this isn't funny anymore! Let me down!  I'll tell Bill on you!!
					-- Microsoft Salesman
User Friendly, 4/1/1998

--MGu/vTNewDGZ7tmp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAhGlyIjReC7bSPZARAl7/AJ4rVVPQft/RaajFyRVhx7F7VF7+rACgvqhQ
6mppcfywrclTAh3U/y5vLAg=
=rfFp
-----END PGP SIGNATURE-----

--MGu/vTNewDGZ7tmp--

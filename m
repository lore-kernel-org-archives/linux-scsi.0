From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Mon, 8 Nov 2004 14:04:31 -0800
Message-ID: <20041108220431.GB17305@one-eyed-alien.net>
References: <418FC117.1040207@adaptec.com> <Pine.LNX.4.44L0.0411081559310.7340-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:56984 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261263AbUKHWEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2004 17:04:37 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0411081559310.7340-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 08, 2004 at 04:03:14PM -0500, Alan Stern wrote:
> On Mon, 8 Nov 2004, Luben Tuikov wrote:
>=20
> > This sounds good.  Just to clarify: if we blacklist in usb-storage, then
> > I think there's no need to also blacklist in SCSI Core as well.  Let sd
> > use the flag to decrement the Returned LBA (effectively assign Returned
> > LBA to capacity rather than increment it and then assign it.)
>=20
> That's right.  Below is the patch.  I'm never quite sure who these things=
=20
> should be submitted to because they apply to both the USB and SCSI=20
> subsystems.  But if it looks good to both of you, I can send it on to=20
> James Bottomley.

Send the SCSI parts to James, I think.  Once they're in, we'll put in the
USB parts.

After this patch, are there any other users of usb_stor_access_xfer_buf()?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBj+1vIjReC7bSPZARAkN3AJ9gwV/NdpaHMd8mqvgfAgYJ/OlctgCdEC8u
EqOCRfY2zgkLrPL2ND9uNE0=
=02OP
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

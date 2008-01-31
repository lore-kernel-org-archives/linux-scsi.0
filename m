From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH 2.6.24] bugfix for an overflow condition in usb storage & isd200.c
Date: Thu, 31 Jan 2008 12:16:16 -0800
Message-ID: <20080131201616.GS14375@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com> <20080131180051.GA22341@kroah.com> <47A22369.80906@panasas.com> <20080131194941.GR14375@one-eyed-alien.net> <47A229FF.4040404@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OxDG9cJJSSQMUzGF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:44230
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756265AbYAaUUh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 15:20:37 -0500
Content-Disposition: inline
In-Reply-To: <47A229FF.4040404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


--OxDG9cJJSSQMUzGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2008 at 10:05:19PM +0200, Boaz Harrosh wrote:
> On Thu, Jan 31 2008 at 21:49 +0200, Matthew Dharm <mdharm-scsi@one-eyed-a=
lien.net> wrote:
> > No.  No no no.
>=20
> Please re-inspect the code again.
> There is no device involved here. The code completely emulates this comma=
nds
> with a driver made up information. the send_to_device is Zero.
> (Nothing to bounce)

Okay, I see what you're doing there, and I can live with that.

> The negative resid is returned by iscsi for ages so I would say the scsi-=
ml
> is fine with it. But if you want I can reset the resid and mark an overfl=
ow
> condition in cmnd->status.

I'd be fine if one of the SCSI guru's would comment on this as being
acceptable.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hey Chief.  We've figured out how to save the technical department.  We=20
need to be committed.
					-- The Techs
User Friendly, 1/22/1998

--OxDG9cJJSSQMUzGF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHoiyQHL9iwnUZqnkRAgw1AJ9QfXWlnzm89XKyNNQtrRB1SMWEOACdHzmL
sRCWAn8TKC9mpXPPJVE0pHs=
=J0N8
-----END PGP SIGNATURE-----

--OxDG9cJJSSQMUzGF--

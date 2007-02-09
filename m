From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] [PATCH]indistinguishable devices with broken and unbroken firmware #2
Date: Fri, 9 Feb 2007 09:44:44 -0800
Message-ID: <20070209174444.GA25000@one-eyed-alien.net>
References: <20070209012053.GE2685@suse.de> <Pine.LNX.4.44L0.0702091029560.4548-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:58381
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992482AbXBISAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 13:00:18 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0702091029560.4548-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, usb-storage@lists.one-eyed-alien.net, Oliver Neukum <oneukum@suse.de>, linux-scsi@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 09, 2007 at 10:30:37AM -0500, Alan Stern wrote:
> On Thu, 8 Feb 2007, Greg KH wrote:
>=20
> > On Thu, Feb 08, 2007 at 09:04:48AM +0100, Oliver Neukum wrote:
> > > Hi,
> > >=20
> > > there's a USB mass storage device which exists in two version. One
> > > reports the correct size and the other does not. Apart from that they
> > > are identical and cannot be told apart. Here's a heuristic based on t=
he
> > > empirical finding that drives have even sizes.
> > >=20
> > > The requested changes have been made.
> > > Greg, can this go through your tree?
> >=20
> > If the usb-storage people ACK it, I'll be glad to add it to my trees.
>=20
> It's okay with me.
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Looks okay to me too.

Acked-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFzLMMHL9iwnUZqnkRAtf9AJ9aVQxtoB1XepVTOIIlOU/WuSQeegCfbgS8
VFUVts5NL99GUcxMTqkRfGA=
=T8oT
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

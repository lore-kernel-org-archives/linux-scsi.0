From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 11:45:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609114515.D5618@one-eyed-alien.net>
References: <20030609162056.GA1857@lst.de> <20030609113247.B5618@one-eyed-alien.net> <20030609183715.GB20308@gtf.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:12806 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264248AbTFISbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:31:41 -0400
Content-Disposition: inline
In-Reply-To: <20030609183715.GB20308@gtf.org>; from jgarzik@pobox.com on Mon, Jun 09, 2003 at 02:37:15PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2003 at 02:37:15PM -0400, Jeff Garzik wrote:
> On Mon, Jun 09, 2003 at 11:32:47AM -0700, Matthew Dharm wrote:
> > Could you please not kill all these fields?  If you want to remove comm=
and,
> > go ahead, but leave the others.
>=20
> What's wrong with the patch?
>=20
> It's just killing explicit zero-inits...

I've just been bitten on the ass by lack of specific initialization before,
so I'm overly careful.

BTW, is NULL =3D=3D (void*)0 everywhere?  I seem to recall places where it
isn't....

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I want my GPFs!!!
					-- Stef
User Friendly, 11/9/1998

--3Pql8miugIZX0722
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+5NW7IjReC7bSPZARAlXHAKCZa6Fv6Tom1+8IViZ1A7cGB3zYLwCdEFgn
k0RcK+yc+GG4fXJpoIkTf9Q=
=rvPs
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--

From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: new driver
Date: Sun, 15 Feb 2004 11:57:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076842642.4441.0.camel@laptop.fenrus.com>
References: <200402141906.12087.kschneider@bout-tyme.net>
	 <20040215092918.A6176@infradead.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4UhFCDR9SmxzXHIK3LHI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:9600 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S262580AbUBOK5k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 05:57:40 -0500
In-Reply-To: <20040215092918.A6176@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ken Schneider <kschneider@bout-tyme.net>, linux-scsi@vger.kernel.org


--=-4UhFCDR9SmxzXHIK3LHI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2004-02-15 at 10:29, Christoph Hellwig wrote:
> On Sat, Feb 14, 2004 at 07:06:12PM -0500, Ken Schneider wrote:
> > I have been sent the sources for the LSI LOGIC, Inc. Ultra ATA100 IDE r=
aid=20
> > controller as found on the mainboard of the HP ML330 computer. I reques=
ted=20
> > information concerning the inclusion of the code into the kernel tree a=
nd=20
> > have been informed that the source is open and can be included as state=
d in=20
> > all of the .c and .h files.
>=20
> We're generally not including software raid as LLDD.  We'd be interested =
in
> both drivers for the underlying ide controller (if not yet support by lin=
ux)
> and a tool to setup the tables for device mapper.

and for 2.4 as ataraid driver; writing one is like a few hours of work
at most so do send a pointer to the source :)



--=-4UhFCDR9SmxzXHIK3LHI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAL1CSxULwo51rQBIRAk3AAJ4nvTvBi3lyHMFHSIBQggej9ep0xACgot7y
CtMwEM4YnWY9ssLvQfa5pGo=
=4WtD
-----END PGP SIGNATURE-----

--=-4UhFCDR9SmxzXHIK3LHI--

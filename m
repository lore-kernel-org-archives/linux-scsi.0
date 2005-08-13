From: Erik Slagter <erik@slagter.name>
Subject: Re: SATA status report updated
Date: Sat, 13 Aug 2005 10:45:59 +0200
Message-ID: <1123922759.4370.1.camel@localhost.localdomain>
References: <42FC2EF8.7030404@pobox.com>
	 <E1E3X1A-00081t-00@chiark.greenend.org.uk>  <42FD14FB.3060200@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P8EqRvuvJjTgMvGw2iDS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oldconomy.demon.nl ([212.238.217.56]:18623 "EHLO
	artemis.slagter.name") by vger.kernel.org with ESMTP
	id S932131AbVHMIqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Aug 2005 04:46:15 -0400
In-Reply-To: <42FD14FB.3060200@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Garrett <mgarrett@chiark.greenend.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org


--=-P8EqRvuvJjTgMvGw2iDS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-08-12 at 17:30 -0400, Jeff Garzik wrote:
> Matthew Garrett wrote:
> > Jeff Garzik <jgarzik@pobox.com> wrote:
> >=20
> >>Things in SATA-land have been moving along recently, so I updated the=20
> >>software status report:
> >>
> >>	http://linux.yyz.us/sata/software-status.html
> >=20
> >=20
> > I couldn't see any reference to system-wide power management (ie,
> > suspend/resume of machines with SATA interfaces) - is any work going on
> > in that area at the moment?
>=20
> Jens Axboe @ SuSE posted a patch that needs some work.  So, it's on the=20
> radar screen, but I haven't seen any new work recently.

Ah, the sata-suspend patch. Also very needed. Extensively used over here
on various kernels (2.6.11 and 2.6.12 versions), no problems, works like
a charm imho.

--=-P8EqRvuvJjTgMvGw2iDS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBC/bNHJgD/6j32wUYRAlMYAJ4mGC70La3nZAviis9nSYpEXolMawCfdKAD
kaKDhd7WrFlkPzlT2HZWBgc=
=rUgW
-----END PGP SIGNATURE-----

--=-P8EqRvuvJjTgMvGw2iDS--

From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [RFR] a new SCSI driver
Date: 25 May 2003 12:45:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053859525.1571.0.camel@laptop.fenrus.com>
References: <200305251119.h4PBJOal000678@81-2-122-30.bradfords.org.uk>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mkRGX6xEcqbmm+QbBkL0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1ea6.a2000.nl ([62.195.30.166]:60398 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S261743AbTEYKdA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 06:33:00 -0400
In-Reply-To: <200305251119.h4PBJOal000678@81-2-122-30.bradfords.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: john@grabjohn.com
Cc: rmk@arm.linux.org.uk, jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


--=-mkRGX6xEcqbmm+QbBkL0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2003-05-25 at 13:19, john@grabjohn.com wrote:
> > > Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardw=
are=20
> > > which could be supported only by an 'old' IDE driver, much like we al=
ready
> > > have at the moment - I.E. we could remove the current 'old' IDE drive=
r
> > > sometime during the 2.7 timescale, and support SATA only via the SCSI=
 layer.
>=20
> > Rubbish.  PIO mode ATA will be around for some years to come - there
> > is just too much invested there (especially in the embedded world) for=20
> > it to vanish this quickly.  For example, think about compact flash card=
s,
> > many of which are still driven using PIO mode accesses in todays PDAs.
>=20
> Why couldn't PDAs be served by the 'old' driver then?  Old doesn't mean o=
bsolete.
>=20
> Also embedded world !=3D PDAs.  I was thinking more of things like PVRs, =
and blade
> servers.  What about solid state video cameras?  Are they going to use PI=
O mode
> ATA?
on common misunderstanding ; PATA !=3D PIO mode ATA but Parallel ATA, as
opposed to Serial ATA

--=-mkRGX6xEcqbmm+QbBkL0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+0J7FxULwo51rQBIRAkKGAKCPMB5jMG6075uZe0vPntIjN38IGwCfTspB
6X67hTOKzVdE9VgTfq1Kjhc=
=auqk
-----END PGP SIGNATURE-----

--=-mkRGX6xEcqbmm+QbBkL0--

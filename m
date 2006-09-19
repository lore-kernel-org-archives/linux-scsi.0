From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] scsi: Switch some more scsi drivers to pci_get_device
	and refcounted pci structures
Date: Mon, 18 Sep 2006 22:10:20 -0400
Message-ID: <1158631820.17671.99.camel@fc6.xsintricity.com>
References: <1158330872.29932.61.camel@localhost.localdomain>
	 <20060918190155.GE17670@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wKI4XWVzm7DQ5bFZNTTD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:15042 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752017AbWISCKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 22:10:31 -0400
In-Reply-To: <20060918190155.GE17670@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


--=-wKI4XWVzm7DQ5bFZNTTD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-09-18 at 20:01 +0100, Christoph Hellwig wrote:
> On Fri, Sep 15, 2006 at 03:34:32PM +0100, Alan Cox wrote:
> > Signed-off-by: Alan Cox <alan@redhat.com>
> >=20
> > diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.va=
nilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c linux-2.6.18-rc6-mm1/driver=
s/scsi/aic7xxx_old.c
> > --- linux.vanilla-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-11 =
17:00:17.000000000 +0100
> > +++ linux-2.6.18-rc6-mm1/drivers/scsi/aic7xxx_old.c	2006-09-14 16:50:25=
.000000000 +0100
> > @@ -9194,7 +9194,7 @@
> >      for (i =3D 0; i < ARRAY_SIZE(aic_pdevs); i++)
> >      {
> >        pdev =3D NULL;
> > -      while ((pdev =3D pci_find_device(aic_pdevs[i].vendor_id,
> > +      while ((pdev =3D pci_get_device(aic_pdevs[i].vendor_id,
> >                                       aic_pdevs[i].device_id,
>=20
> NACK.  This doesn't help us forward at all.  In case you have
> the hardware please do a full conversion to the real pci probing API.

OMG, does anyone still use that thing?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-wKI4XWVzm7DQ5bFZNTTD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFD1GMg6WylM+/8ZQRAi3hAJ4yun2OVO4mkZWM40XIzQeVf8pCEQCcDiX3
SGsiO3E8Dh0tqodwsBkjgzo=
=P9xC
-----END PGP SIGNATURE-----

--=-wKI4XWVzm7DQ5bFZNTTD--


From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: pulling failover out of qla2xxx
Date: Sat, 17 Jan 2004 22:08:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074373727.4429.4.camel@laptop.fenrus.com>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
	 <40084860.90902@pobox.com>  <20040117205230.GB8301@praka.local.home>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LC5uiVneQeXrsKmNHuK5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:36483 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S266171AbUAQVJD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 16:09:03 -0500
In-Reply-To: <20040117205230.GB8301@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>


--=-LC5uiVneQeXrsKmNHuK5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-01-17 at 21:52, Andrew Vasquez wrote:
> On Fri, 16 Jan 2004, Jeff Garzik wrote:
>=20
> > >I'll open up a request-for-response from the rest of the listers in
> > >asking if parceling out qlaAB00.ko modules based on firmware types is
> > >both practical and sensible from a user standpoint.  Especially
> > >considering that many users aren't really concerned with the ISP chip
> > >type on their QLAXXXX or OEM-BRANDED ABC host bus adapter.
> >=20
> >=20
> > Speaking from a generic driver / distro standpoint, module dependencies=
=20
> > and PCI tables (i.e. pci_device_id and MODULE_DEVICE_TABLE) all things=20
> > to magically Just Work :)
> >=20
>=20
> I certainly hope this to be the case.  Perhaps I'm still viewing this
> with an eye as an external module maintainer.  When a user compiles
> the qla2xxx driver she's given the following options:
>=20
> 	...
>         [ ] QLogic ISP2100 host adapter family support
>         [ ] QLogic ISP2200 host adapter family support
>         [ ] QLogic ISP2300 host adapter family support
>         [ ] QLogic ISP2322 host adapter family support
>         [ ] QLogic ISP6312 host adapter family support
>         [ ] QLogic ISP6322 host adapter family support
> 	...
>=20
> how will she know which option to select for her QLA2362 HBA? =20

fwiw there is no rule to have a Kconfig line for each driver; you could
just have one "QLogic fiber channel drivers" question, maybe with a
subquestion about "enable all chipsets" with a pull down thingy for
selected ones if the user wants to pick and choose. There is also help
text for more info.
(and most people who have qlogic fiber adapters will just say "m" to
all, as will distros)

--=-LC5uiVneQeXrsKmNHuK5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBACaRfxULwo51rQBIRAlx1AJ9h0N78JL0WZSrUGAcyjU1Qp02PPgCgqwmB
saaQLCzSFl4EpJEERJ6fsM8=
=RVFu
-----END PGP SIGNATURE-----

--=-LC5uiVneQeXrsKmNHuK5--

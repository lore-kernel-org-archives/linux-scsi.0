From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [rant] can we get asane ic7xxx/79xx probing _please_
Date: Wed, 08 Sep 2004 15:16:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094649419.2800.12.camel@laptop.fenrus.com>
References: <20040906182402.GA25103@lst.de>  <413F01C3.9020202@adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bvI3yNjTBlj6pwuM1QPN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43689 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S267455AbUIHNRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 09:17:10 -0400
In-Reply-To: <413F01C3.9020202@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org


--=-bvI3yNjTBlj6pwuM1QPN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-09-08 at 14:57, Luben Tuikov wrote:
> Hi Christoph,
>=20
> Thanks for bringing this up.  I do have Andi's patch in the pending list,
> and would like to apply it to the newer version of the driver.
>=20
> I should mention that while the newer drivers do not quite have
> the PCI tables as presented in Andi's patch, they do check the return
> value of pci_module_init() and return the appropriate result.

please please please provide linux compliant MODULE_DEVICE_TABLE's.
Operating system hardware probing apps *require* those for device
probing; right now there are very ugly hacks especially for aic7xxx that
should go away.


--=-bvI3yNjTBlj6pwuM1QPN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBPwZLxULwo51rQBIRAt2cAJ0c2NDPCeh0h5PwdXfFsNBcxBvkqACeImbT
xXJfE8gtQWmFG03ckcuzNnw=
=Ujbs
-----END PGP SIGNATURE-----

--=-bvI3yNjTBlj6pwuM1QPN--


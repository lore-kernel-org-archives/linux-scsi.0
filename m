From: Arjan van de Ven <arjanv@redhat.com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Thu, 10 Jun 2004 15:36:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086874608.2733.10.camel@laptop.fenrus.com>
References: <3356669BBE90C448AD4645C843E2BF28034F9490@xbl.ma.emulex.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eC7khm/k7T05M2co0eBF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:25551 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261252AbUFJNg5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 09:36:57 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9490@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org


--=-eC7khm/k7T05M2co0eBF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> I am simply making a point that :=20
> I think it's too much to demand that all external entry points be removed=
.

is it? Christoph has a point in that the users of such points surely can
be added to the kernel too? Maybe we can even make some of those more
generic and have a driver testing/hardening framework in the scsi
midlayer.

However I must say that just some hooks for "invisible" stuff that
significantly crap up a driver are a mistake in my opinion and should be
removed. Quite often such things stand in the way of real cleanups and
restructuring for example.


--=-eC7khm/k7T05M2co0eBF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAyGPwxULwo51rQBIRArJyAKCB/tod4SwHUW1b/8V99ftE8j9ezgCfcf8A
PEq0xh94AVgl8xFD0VuKtrA=
=nwUq
-----END PGP SIGNATURE-----

--=-eC7khm/k7T05M2co0eBF--


From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 17:27:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087313241.2710.40.camel@laptop.fenrus.com>
References: <40CF0F9F.4050902@adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CRui9zShyh3BEM2MtSju"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:24478 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265691AbUFOP1Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 11:27:25 -0400
In-Reply-To: <40CF0F9F.4050902@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-CRui9zShyh3BEM2MtSju
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-06-15 at 17:02, Luben Tuikov wrote:
> Hello,
>=20
> This patch introduces a flexible command timeout infrastructure
> accomodating completely current behaviour SCSI Core command timeout,
> but also offering the ability to hand command timeout handling to
> a LLDD, _yet_ still have it all go through *SCSI Core*.

to me it somewhat sounds like the wrong approach.
I'm all for the LLDD to be able to influence the timeout value, but I
consider it a bad mistake to make every driver reinvent timeout
*handling*.


--=-CRui9zShyh3BEM2MtSju
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAzxVZxULwo51rQBIRAkOzAKCnos7fN7TzBCDCLC8KSBJR973icwCfSTx7
5+7fisRxH+THfTINYGaqAk8=
=9yBd
-----END PGP SIGNATURE-----

--=-CRui9zShyh3BEM2MtSju--


From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Thu, 11 Nov 2004 09:01:20 +0100
Message-ID: <1100160080.2646.10.camel@laptop.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta>
	 <20041110220854.GB28524@lists.us.dell.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yiloRAIiMIUQ7c+ABpL6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22659 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262188AbUKKICq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2004 03:02:46 -0500
In-Reply-To: <20041110220854.GB28524@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


--=-yiloRAIiMIUQ7c+ABpL6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-11-10 at 16:08 -0600, Matt Domsch wrote:

> How about you remove all the PCI IDs from the 2.00.3 driver that the
> 2.20 driver handles, so that they're mutually exclusive again?

Are they mutually exclusive in other places too? (eg in the /proc stuff
it creates... well I guess the new driver only does (or should do) sysfs
of course)


--=-yiloRAIiMIUQ7c+ABpL6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBkxxQpv2rCoFn+CIRAjOLAKCF304pSa7LxICdzzfbu2NlzBfslACdGzA0
kd7XTBzkAFKSTDOJDdT0Hpk=
=+S9Q
-----END PGP SIGNATURE-----

--=-yiloRAIiMIUQ7c+ABpL6--


From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx
	drivers
Date: Mon, 21 Jun 2004 17:37:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087832273.2702.14.camel@laptop.fenrus.com>
References: <20040621161441.20dfcee6.ak@suse.de>
	 <40D6FEFC.9050005@adaptec.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vENJQbUYpEpWfpkHmCip"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:13004 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266275AbUFUPiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 11:38:08 -0400
In-Reply-To: <40D6FEFC.9050005@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org


--=-vENJQbUYpEpWfpkHmCip
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-06-21 at 17:30, Luben Tuikov wrote:
> Thank you Andi for the patches. aic7xxx drivers are due for update
> to use the new timeout infrastructure. I'll incorporate them in,
> and do some testing.

cool.
Would you please consider the update to be done in small incremental
changes/steps ? Eg each separate change/bugfix a separate patch ?
Would make life a lot easier for me (distro kernel guy) and for James to
be able to diagnose regressions a lot better by binary searching
changesets etc etc.

Greetings,
   Arjan van de Ven

--=-vENJQbUYpEpWfpkHmCip
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA1wDQxULwo51rQBIRAnxpAJ42Dhz7g10Bvdsrykh024xoOt+z2QCgjYKM
nEG9BMxhluBECxpdL2z1jpk=
=CaKI
-----END PGP SIGNATURE-----

--=-vENJQbUYpEpWfpkHmCip--


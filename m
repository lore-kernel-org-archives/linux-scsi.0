From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: RE: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Thu, 03 Mar 2005 10:48:35 +0100
Message-ID: <1109843315.3666.103.camel@ilfb02.ilsb.tuwien.ac.at>
References: <0E3FA95632D6D047BA649F95DAB60E5703662708@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-of99a9trd+Pp+Oy0nSCS"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:30617 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262069AbVCCJsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Mar 2005 04:48:50 -0500
Received: from ilfb02.ilsb.tuwien.ac.at (ilfb02.ilsb.tuwien.ac.at [128.130.71.3])
	by gh-gw1.ilsb.tuwien.ac.at (8.12.3/8.12.3/Debian-7.1) with ESMTP id j239meZH032666
	for <linux-scsi@vger.kernel.org>; Thu, 3 Mar 2005 10:48:41 +0100
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662708@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>


--=-of99a9trd+Pp+Oy0nSCS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-03-02 at 13:21 -0500, Ju, Seokmann wrote:
> On Wednesday, March 02, 2005 6:42 AM, Gerhard wrote:
> > It's a megaraid issue (not a tape issue..)
>=20
> We are looking at this issue and will post here for details.
> What version of megaraid driver and which megaraid controller are you usi=
ng?
>=20
> Thanks,
>=20
> Seokmann
> LSI Logic Corporation.
>=20

A very stupid question to everybody..

Could it be that it's not a tape issue but a scheduler issue?
It seems that when using tar on a 2.4 kernel tar is getting much more
CPU time. Either the scheduler is much better or it's slowing down
tape I/O..

Is the combination of different disk and tape drivers able to trigger
different IO Scheduler problems?

                                            GS

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-of99a9trd+Pp+Oy0nSCS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCJt1zE6e53f4wQG4RAqSqAJ45OCKwmKN/yS9vQzy4iLfFTFmrWgCeMlyb
9qyuPaLZJGUjFEziRrAnh10=
=UFtg
-----END PGP SIGNATURE-----

--=-of99a9trd+Pp+Oy0nSCS--


From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: RE: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Fri, 25 Feb 2005 09:18:22 +0100
Message-ID: <1109319502.5896.109.camel@ilfb02.ilsb.tuwien.ac.at>
References: <0E3FA95632D6D047BA649F95DAB60E57036626F0@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bHEHiGoE+Vp/q/iSEFWH"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:7595 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262649AbVBYISo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 03:18:44 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57036626F0@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: scsi <linux-scsi@vger.kernel.org>


--=-bHEHiGoE+Vp/q/iSEFWH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-02-24 at 16:45 -0500, Ju, Seokmann wrote:
> On Wednesday, February 23, 2005 6:45 AM, Gerhard wrote:
> > To: linux-scsi@vger.kernel.org
> > Subject: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
> >=20
> >=20
> > Kernel: 2.6.10-rc4 w/ 3 tape patches from Kai Makisara
> I'm not sure, but have you tried without those patches?
>=20
> >=20
> > SCSI: 53C1030 controller, tape drive is on one channel of the
> > controller.
> >=20
> > Tape: Overland Changer w/ Seagate LTO-1 drive
> > Typical transfer speed: 12MB/s
> >=20
> > After adding a Megaraid Zero Channel Raid Controller to that
> > computer the transfer speed of the tape changed to 2.6 MB/s
> What is driver version that you are using?
>=20
> Thanks,
> Seokmann
> LSI Logic Corporation.

Linux driver:=20
Release Date    : Thu Feb 03 12:27:22 EST 2005 - Seokmann Ju
<sju@lsil.com>
Current Version : 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)

Megaraid firmware: 1Z37
Both channels limited to Ultra-160

Thank you in advance!
                                   Gerhard Schneider

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-bHEHiGoE+Vp/q/iSEFWH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCHt9OE6e53f4wQG4RAjyhAKD7/XO51y8xwPgMYirj3aEvgkmmSwCeMH1A
ykQIR7hl18222uFAmfnvVz4=
=BRdx
-----END PGP SIGNATURE-----

--=-bHEHiGoE+Vp/q/iSEFWH--


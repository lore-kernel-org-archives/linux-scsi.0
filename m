From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: RE: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Wed, 02 Mar 2005 17:00:09 +0100
Message-ID: <1109779209.3666.91.camel@ilfb02.ilsb.tuwien.ac.at>
References: <200503021550.j22Fo3516250@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Io2PoD+HimN5TyKglpcQ"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:14749 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262336AbVCBQAP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 11:00:15 -0500
In-Reply-To: <200503021550.j22Fo3516250@www.watkins-home.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'scsi' <linux-scsi@vger.kernel.org>


--=-Io2PoD+HimN5TyKglpcQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-03-02 at 10:49 -0500, Guy wrote:
> You did:
> dd if=3D/dev/zero of=3D/dev/nst0 bs=3D1M     and different mt setblk
>=20
> Since tape drives can compress data, /dev/zero is a bad source of data,
> since it compresses real good.  /dev/urandom is a better source.
>=20
> You would like IBM's LTO-2 tape drive.  It does 35M/s!  They claim the LT=
O-3
> does 70M/s!
>=20
> Guy
>=20
I did want the tape to do NOTHING. It's a test of the SCSI transfer
speed, handshake etc.=20
When compression is on the tape has to write file marks and very little
information. So you get the real transfer performance. Not the
performance of the tape.

                                                   GS

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-Io2PoD+HimN5TyKglpcQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCJeMJE6e53f4wQG4RArHuAKC1z+BpE/d+Fl1N3uAAxbCeuR2hLgCeOCyS
4MPlcoh7rL7DOKAH+VJvj3w=
=W8MP
-----END PGP SIGNATURE-----

--=-Io2PoD+HimN5TyKglpcQ--


From: Philip Hands <phil@hands.com>
Subject: Re: need help diagnosing sym53c1010-33/Fujitstu MAN3367MP/raid1
	lockups
Date: 09 Jul 2002 10:32:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1026207164.10874.8402.camel@palm>
References: <20020702035227.G3415-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-T1Jcj9AW3qho09umgdil"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020702035227.G3415-100000@localhost.my.domain>
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?G=E9rard?= Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org


--=-T1Jcj9AW3qho09umgdil
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Tue, 2002-07-02 at 03:00, G=E9rard Roudier wrote:
>=20
> Just quoting a couple of relevant error messages:
>=20
> > Jul  3 09:18:54 comet kernel: sym0:0: ERROR (0:48) (a-2c-0) (27/18/c0) =
@ (scripta 220:84000000).
>=20
> SIST=3D0x48  bit 0x8 means SCSI GROSS ERROR.
>=20
> > Jul  3 09:25:23 comet kernel: sym0:1: ERROR (81:0) (e-ae-0) (3e/18/80) =
@ (scripta 80:1e000000).
>=20
> DSTAT=3D0x81  bit 0x1 means ILLEGAL INSTRUCTION DETECTED
>=20
> Can be the result of the device asserting the SCSI REQ signal when the
> initiator is expecting it to release the SCSI BUS.
>=20
> Some other error messages indicate some bad relection which is extremally
> severe in SCSI.
>=20
> I would recommend you to check the SCSI BUS.. Switch cable and/or
> terminators for example, etc...

I've tried 3 cables, and two terminators, all bought brand-new, from
separate sources.

Is it really that common for SCSI cables to be defective?

If so, is there a better way of testing them than simply buying more &
more until something works?

What are the chances that either the controller or the drives could be
the problem?  Is there some way of diagnosing them (other than buying
replacements, which seems like an expensive, and possibly fruitless
approach)?

Sorry for the trivial questions, but it seems strange to me that what is
supposed to be a broken setup could achieve almost theoretical maximum
transfer rates when TCQ is switched off, but starts spewing errors at an
enormous rate when TCQ is switched on.

Cheers, Phil.
--=20
Say no to software patents!  http://petition.eurolinux.org/

|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-T1Jcj9AW3qho09umgdil
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9Kq28YgOKS92bmRARAjZtAKCsCvcvd+ujErmoZmzYfJKz4a72FACfZrAd
itPls8VdOyZQ3XE8LtfoygQ=
=BO8B
-----END PGP SIGNATURE-----

--=-T1Jcj9AW3qho09umgdil--

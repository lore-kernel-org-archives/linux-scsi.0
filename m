From: Philip Hands <phil@hands.com>
Subject: Re: need help diagnosing sym53c1010-33/Fujitstu MAN3367MP/raid1
	lockups
Date: 09 Jul 2002 23:17:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1026253048.10874.16123.camel@palm>
References: <20020710024132.F4372-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-WwnuzISbLiSb0CCyHRJL"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020710024132.F4372-100000@localhost.my.domain>
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?G=E9rard?= Roudier <groudier@free.fr>
Cc: linux-scsi@vger.kernel.org


--=-WwnuzISbLiSb0CCyHRJL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Wed, 2002-07-10 at 02:23, G=E9rard Roudier wrote:

> Now that we know that cable and terminators are ok, you may try, for
> example, to lower the data transfer speed. This will reduce the stress fo=
r
> all the parts connected to the SCSI BUS and will allow more margin for
> SCSI signaling. Result can give some new clue.

I tried that before switching off the TCQ.

It gave similar behaviour all the way down to 20MB/s (I may have tried
10MB/s, but I'm not sure.  If I did, it didn't work either).

Cheers, Phil.
--=20
Say no to software patents!  http://petition.eurolinux.org/

|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-WwnuzISbLiSb0CCyHRJL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9K2D4YgOKS92bmRARAmjbAJ0Xnt5pheLeypK4Dprnlaa/Rd6o8ACglIAX
a1F62AKkIhzx4wd1De+U3FE=
=IkLZ
-----END PGP SIGNATURE-----

--=-WwnuzISbLiSb0CCyHRJL--

From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Wed, 02 Mar 2005 11:30:28 +0100
Message-ID: <1109759428.3666.77.camel@ilfb02.ilsb.tuwien.ac.at>
References: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
	 <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
	 <1109323141.5896.124.camel@ilfb02.ilsb.tuwien.ac.at>
	 <Pine.LNX.4.61.0502272239580.17367@kai.makisara.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dk3IP0PuJ4oOUOVoQDY2"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:6812 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262253AbVCBKaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 05:30:52 -0500
In-Reply-To: <Pine.LNX.4.61.0502272239580.17367@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: scsi <linux-scsi@vger.kernel.org>


--=-dk3IP0PuJ4oOUOVoQDY2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2005-02-27 at 22:46 +0200, Kai Makisara wrote:

>=20
> This shows that your application is not using very large block size (3=20
> pages, 10 kB?). You might get better throughput with larger block size (3=
2=20
> kB or 64 kB is usually large enough). If the Megaraid command processing=20
> speed is not fast enough, this might explain the problem (not probable bu=
t=20
> I can't see any probable problems ;-)
>=20

After different tries (I had problems w/ my backup schedule - ever tried
to back up 600 GB with 2.6MB/s? :-)

Tape block sizes between 10k and a few MB don't make any difference

For better understanding I did the tests with

dd if=3D/dev/zero of=3D/dev/nst0 bs=3D1M     and different mt setblk

No chance to go above 2.6 MB/s

                                    Gerhard Schneider

--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-dk3IP0PuJ4oOUOVoQDY2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCJZXEE6e53f4wQG4RAkJ6AJ9ZynNXVFuOB5NHopeCSu4UBq+VYgCgu4aX
U6wDYNHur5jwxFntZrPN6yo=
=//YR
-----END PGP SIGNATURE-----

--=-dk3IP0PuJ4oOUOVoQDY2--


From: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Subject: Re: 2.6.10-rc4 tape slow after switch Fusion MPT to Megaraid
Date: Wed, 02 Mar 2005 12:42:15 +0100
Message-ID: <1109763735.3666.81.camel@ilfb02.ilsb.tuwien.ac.at>
References: <1109159088.5896.36.camel@ilfb02.ilsb.tuwien.ac.at>
	 <Pine.LNX.4.61.0502242246420.9332@kai.makisara.local>
	 <1109323141.5896.124.camel@ilfb02.ilsb.tuwien.ac.at>
	 <Pine.LNX.4.61.0502272239580.17367@kai.makisara.local>
	 <1109759428.3666.77.camel@ilfb02.ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UnEA80VO2IB1qUXmeebx"
Received: from gh-gw1.ilsb.tuwien.ac.at ([128.130.23.14]:60353 "EHLO
	gh-gw1.ilsb.tuwien.ac.at") by vger.kernel.org with ESMTP
	id S262281AbVCBLms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 06:42:48 -0500
In-Reply-To: <1109759428.3666.77.camel@ilfb02.ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: scsi <linux-scsi@vger.kernel.org>


--=-UnEA80VO2IB1qUXmeebx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-03-02 at 11:30 +0100, Gerhard Schneider wrote:
> On Sun, 2005-02-27 at 22:46 +0200, Kai Makisara wrote:
>=20
> >=20
> > This shows that your application is not using very large block size (3=20
> > pages, 10 kB?). You might get better throughput with larger block size =
(32=20
> > kB or 64 kB is usually large enough). If the Megaraid command processin=
g=20
> > speed is not fast enough, this might explain the problem (not probable =
but=20
> > I can't see any probable problems ;-)
> >=20
>=20
> After different tries (I had problems w/ my backup schedule - ever tried
> to back up 600 GB with 2.6MB/s? :-)
>=20
> Tape block sizes between 10k and a few MB don't make any difference
>=20
> For better understanding I did the tests with
>=20
> dd if=3D/dev/zero of=3D/dev/nst0 bs=3D1M     and different mt setblk
>=20
> No chance to go above 2.6 MB/s
>=20

Moved the tape drive to another machine w/Fusion chipset, but w/o
Megaraid controller. Absolutely the same software.

dd if=3D/dev/zero of=3D/dev/nst0 bs=3D1M count=3D1000
1000+0 records in
1000+0 records out
1048576000 bytes transferred in 24.597061 seconds (42630134 bytes/sec)

That's the transfer rate the tape drive is able when receiving bullshit
(/dev/zero).

It's a megaraid issue (not a tape issue..)

                                             GS

changing all backup scripts to the new machine
--=20
Gerhard Schneider
Institute of Lightweight Design and          e-Mail:gs@ilsb.tuwien.ac.at
Structural Biomechanics (E317)               Tel.:   +43 1 58801 31716
Vienna University of Technology / Austria    Fax:    +43 1 58801 31799
A-1040 Wien, Gusshausstrasse 27-29    http://www.ilsb.tuwien.ac.at/~gs/


--=-UnEA80VO2IB1qUXmeebx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCJaaXE6e53f4wQG4RAvVoAKDsSZauo68wAce/snibNE1llbCS6QCgv9S8
TKpYHl8zFsEsJpvcQPtzHjs=
=0EKC
-----END PGP SIGNATURE-----

--=-UnEA80VO2IB1qUXmeebx--


From: Craig Bradney <cbradney@zip.com.au>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Sun, 18 Jan 2004 21:33:34 +0100
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <1074458014.31271.20.camel@athlonxp.bradney.info>
References: <20031203204445.GA26987@gtf.org>
	 <200401181432.55736.adasi@kernel.pl>  <400AC9BA.1020103@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-868gRDnrhTKLd+MqRA6Q"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <400AC9BA.1020103@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Witold Krecicki <adasi@kernel.pl>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-868gRDnrhTKLd+MqRA6Q
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable

On Sun, 2004-01-18 at 19:00, Jeff Garzik wrote:
> Witold Krecicki wrote:
> > Dnia Wednesday 03 of December 2003 21:44, Jeff Garzik napisa=B3:
> >=20
> >>Editor's preface:  This is clearly a first draft, only covering the
> >>basics.  In order for this document to be effective, I request that
> >>users and developers send me (or post) their SATA driver questions and
> >>issues.  I will do my best to address them here.
> >>
> >>
> >>Serial ATA (SATA) for Linux
> >>status report
> >>Dec 3, 2003
> >=20
> > What about SMART capabilities? with sii3112 I had it, but with libata I=
 cannot=20
> > get any informations :/
>=20
>=20
> Currently do not support random userland programs throwing random ATA=20
> commands at us...  so no SMART support at present :)  It's coming, though=
.


On the note of SATA interfaced drives, is there a way to power them
down?=20

I have recently attached my spare PATA drive with a converter and use it
just for backups (mount, rsync, umount). I have these configured through
SCSI (/dev/sda) with the 3112 2.6.1 support. hdparm comlains the drive
is SCSI... is there a similar command to power it down?

thanks
Craig

--=-868gRDnrhTKLd+MqRA6Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBACu2ei+pIEYrr7mQRAu4/AJ9QApNr/BrkD3FD74ntH9ywozKC9gCeLZGF
AMh9CIptcMcikyuMAPPHCZw=
=Riov
-----END PGP SIGNATURE-----

--=-868gRDnrhTKLd+MqRA6Q--


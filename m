From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: Re: bus:id:lun to device name
Date: 15 Jul 2003 16:45:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058280356.3983.29.camel@lt-sv>
References: <1057159447.825.68.camel@lt-sv>
	 <20030708145007.GQ2601@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bVhwLeJn4msjXHu0Uu+O"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pong.to.com ([194.221.251.36]:18181 "EHLO pong.to.com")
	by vger.kernel.org with ESMTP id S268019AbTGOObq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 10:31:46 -0400
In-Reply-To: <20030708145007.GQ2601@nbkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: linux-scsi@vger.kernel.org


--=-bVhwLeJn4msjXHu0Uu+O
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On Tue, 2003-07-08 at 16:50, Kurt Garloff wrote:
> Hi Stefan,
>=20
> On Wed, Jul 02, 2003 at 05:24:08PM +0200, Stefan Voelkel wrote:
> > I want to convert a bus:id:lun triple to something like "/dev/sda".
> >=20
> > From userspace I can ioctl() /dev/s[d|cd|...]* or parse /proc/scsi/scsi=
.
>=20
> Plain /proc/scsi/scsi does not help you.
> You may want to have a lok at the scsi-many patches that export this
> information via /proc/scsi/scsi though.
> http://www.suse.de/~garloff/linux/scsi-many/

I can not patch the middle layer.

> Host: scsi3 Channel: 00 Id: 10 Lun: 00
>   Vendor: IBM      Model: DDYS-T18350N     Rev: S84D
>   Type:   Direct-Access                    ANSI SCSI revision: 03
>   Attached drivers: sde(b:08:40) sg5(c:15:05)
>=20
> > I do not like any of those solutions.
>=20
> For non-removable harddisks, the ioctl() just works fine, BTW.
> I see no reason to dislike it.

Theoretically /dev/foobar might be a scsi device, meaning that I
must/should ioctl() all files under /dev/. Thats what I do not like
about ioctl() :).

> Another option is to use scsidev
> http://www.garloff.de/kurt/linux/scsidev/
> where the device nodes are dynamically created and (by default) have=20
> names which contain this information.

AFAIR devfs does this too, depending on devfs would be an option.

regards
	Stefan
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-bVhwLeJn4msjXHu0Uu+O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/FBOjtWF28C4HGsQRAkTPAJ93drKzb5zmFpahmVrMvg1PEqcZ7QCgv3VI
NmzYbj5xx/HfQ5F383tj6FQ=
=HCtx
-----END PGP SIGNATURE-----

--=-bVhwLeJn4msjXHu0Uu+O--


From: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Subject: Re: LUN resizing
Date: Fri, 28 Nov 2003 11:08:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069965713.886.38.camel@lt-sv>
References: <1069708054.26088.127.camel@lt-sv>
	 <1069774983.2061.28.camel@mulgrave> <1069776713.1787.36.camel@mulgrave>
	 <1069839911.26091.443.camel@lt-sv>  <20031126094804.A2717@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9J/tIaEVz/0lcxGAczV6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ping.topalis.com ([195.243.109.4]:32006 "EHLO ping.topalis.com")
	by vger.kernel.org with ESMTP id S262106AbTK1KJK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 05:09:10 -0500
In-Reply-To: <20031126094804.A2717@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-9J/tIaEVz/0lcxGAczV6
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

On Wed, 2003-11-26 at 10:48, Christoph Hellwig wrote:
> On Wed, Nov 26, 2003 at 10:45:11AM +0100, Stefan Voelkel wrote:
> >       * a way to force the scsi stack to send out a read_capacity and
> >         act on it (perhaps another /sys/ entry?), perhaps a hotplug
> >         event that creates a new partition table, eg add the new space
> >         as "unused" at the end of the device, write that table and
> >         ioctl() to reread it.
> >       * a way to fiddle around with live partitions,  a userspace tool
> >         with a way to tell the kernel supsend/reactivate io on that
> >         block device. it would have to take care of the filesystems
> >         residing on the device.
>=20
> No way.  You're better of using a proper volume manager instead of doing
> this paritioning mess.

True, let's forget about the partitions: mount /dev/sda /home.=20
--=20
--------------------------------------------------------------------
Stefan V=F6lkel                            stefan.voelkel@millenux.com
Millenux GmbH                              mobile: +49.170.79177.17
Lilienthalstra=DFe 2                          phone: +49.711.88770.300
70825 Stuttgart-Korntal                       fax: +49.711.88770.349
     -=3D linux without limits -=3D- http://linux.zSeries.org/ =3D-

--=-9J/tIaEVz/0lcxGAczV6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/xmGRtWF28C4HGsQRAqcDAJ9ndUrZYaURTzV2fsyBSztgxoJ6iACgvLWG
BXeNb+TyGUkOdS7eNiMnitw=
=oIyP
-----END PGP SIGNATURE-----

--=-9J/tIaEVz/0lcxGAczV6--


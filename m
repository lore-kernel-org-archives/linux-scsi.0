From: Paul Blazejowski <paulb@blazebox.homeip.net>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Mon, 04 Aug 2003 14:26:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060021614.889.6.camel@blaze.homeip.net>
References: <20030801182207.GA3759@blazebox.homeip.net>
	 <20030801144455.450d8e52.akpm@osdl.org>
	 <20030803015510.GB4696@blazebox.homeip.net>
	 <20030802190737.3c41d4d8.akpm@osdl.org>
	 <20030803214755.GA1010@blazebox.homeip.net>
	 <20030803145211.29eb5e7c.akpm@osdl.org>
	 <20030803222313.GA1090@blazebox.homeip.net>
	 <20030803223115.GA1132@blazebox.homeip.net>
	 <20030804093035.A24860@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VSWhQFHkYzuLcryA98i/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pool-141-155-151-209.ny5030.east.verizon.net ([141.155.151.209]:62418
	"EHLO mail.blazebox.homeip.net") by vger.kernel.org with ESMTP
	id S272131AbTHDSYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 14:24:49 -0400
In-Reply-To: <20030804093035.A24860@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>


--=-VSWhQFHkYzuLcryA98i/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2003-08-04 at 12:30, Patrick Mansfield wrote:
> On Sun, Aug 03, 2003 at 06:31:15PM -0400, Diffie wrote:
> > On Sun, Aug 03, 2003 at 06:23:13PM -0400, Diffie wrote:
>=20
> > > Thank you for all your help.Sorry but i gave the wrong URL in previou=
s
> > > email.The correct one is http://www.blazebox.homeip.net:81/diffie/ima=
ges/linux-2.6.0-test2/
> > >=20
>=20
> Per your screen dump - it found the cd-rom's on id 3 and 4, but not your
> disk drive that was at id 0, and the adapter found something at id 6 (hos=
t
> adapter is at id 7).
>=20
> You could try turning on scan logging, it might give more information.
> You can turn on the logging at boot time, make sure you have
> CONFIG_SCSI_LOGGING on, the information of interest (scan of host 0 chan =
0
> id 0 lun 0) likely will scroll off screen.
>=20
> For scan logging, add to your boot line:
>=20
> 	scsi_mod.scsi_logging_level=3D0x140
>=20
> To limit the logging info, make sure max_scsi_luns=3D1 via config or boot
> time option scsi_mod.max_scsi_luns=3D1.
>=20
> -- Patrick Mansfield
>=20

Patrick,

I enabled CONFIG_SCSI_LOGGING=3Dy in kernel then i used
scsi_mod.scsi_logging_level=3D0x140 and scsi_mod.max_scsi_luns=3D1 when
booting the kernel from lilo.I can see some debug information scroll on
the screen and i did see ID0 LUN0 get probed even the correct transfer
rate for the SCSI disk is set.I forgot but isn't there a key sequence
when pressed it will stop the screen output like pause/break key?

I have few screen snaps which can be viewed at=20
http://www.blazebox.homeip.net:81/diffie/images/linux-2.6.0-test2/aic7xxx/

Thanks for your help.

Paul B.

--=-VSWhQFHkYzuLcryA98i/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/LqVuIymMQsXoRDARAj6EAJ4y34xfIwSrliWvA+g2BZlv7yL61gCeP3oK
BFIG8dtHtM2PKeLFqI4FWL8=
=BY1o
-----END PGP SIGNATURE-----

--=-VSWhQFHkYzuLcryA98i/--


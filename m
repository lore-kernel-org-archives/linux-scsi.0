From: Joerg Wendland <wendland@scan-plus.de>
Subject: mysterious qlogicfc effects
Date: Fri, 3 May 2002 00:01:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020502220153.GA13889@morpheus.ulm.scan-plus.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from joerg by morpheus.ulm.scan-plus.de with local (Exim 3.35 #1 (Debian))
	id 173Oe9-000468-00
	for <linux-scsi@vger.kernel.org>; Fri, 03 May 2002 00:01:53 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi SCSI folks,
I have got an qlogic QLA2200 controller attached to a FC-net. I am trying
to use an attached RAID but the qlogicfc (stock 2.4.18) driver only recogni=
zes=20
it when I build it as a module, load it, unload it and load it for a second=
=20
time. When I load it once or when I compile it into the kernel, I get only a

> qlogicfc0: link is not up

and about 50 lines saying:

> resize_dma_pool: unknown device type 31
(that my come from some 'unknown' scsi devices with type 0x1f on the fc-net)

and I have no chance accessing the RAID. First I though that could be a
timeout problem, so I backported the patch from alan@lxorguk.ukuu.org.uk
in 2.4.19-pre5. That and playing around with the patched waiting loop didn't
help anything. The hub (a vixel 2100) reports the port connected to the
controller is up and in the correct loop but I cannot access the RAID.

Any objections to this? I searched the list archives and google but could
not find any answer.

Any help appreciated, thanks in advance,

  Joerg

PS: my machine config
dual athlon 1800MP with 2GB RAM
qlogic qla2200
stock kernel 2.4.18 with builtin qlogicfc driver with and without firmware

--=20
| Joerg Wendland (system management)    | Debian certified GNU/Linux Develo=
per |
| Scan-Plus GmbH                        |                fon +49-731-92013-=
0   |
| Moerikestrasse 5, 89077 Ulm, Germany  |                fax +49-731-92013-=
290 |
| PGP-key: 51CF8417 (FP: 79C0 7671 AFC7 315E 657A  F318 57A3 7FBD 51CF 8417=
)   |

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE80bdRV6N/vVHPhBcRAnpDAJ0UXjbnYP1zReW/VEoMnkBljNqnCgCgjfa+
fVkODdtsTppWCDBoBWAdnG8=
=xm4H
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--

From: Kurt Garloff <garloff@suse.de>
Subject: scsi-many ported to 2.4.21
Date: Wed, 9 Jul 2003 21:38:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709193800.GX10137@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nbhonbzV/xpXxmuC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([213.95.15.193]:39948 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S268512AbTGITXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 15:23:24 -0400
Received: from Hermes.suse.de (Hermes.suse.de [213.95.15.136])
	by Cantor.suse.de (Postfix) with ESMTP id 2C3FE14E03
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2003 21:38:01 +0200 (MEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--nbhonbzV/xpXxmuC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I ported the scsi-many patches to 2.4.21.
The patches provide a possibility to support a large number of SCSI
devices with Linux - 2.4 kernels. Support for 2000 disks and even more
sg devices is provided, based on dynamic allocation of block majors
(after the first 16 defined ones).
There are also patches to provide an enhancement to /proc/scsi/scsi=20
(can be switched on and off) to report the high-level devices
attached to a low-level device. A patch for a boot parameter
root=3D/dev/scsi/sdcHbCtIuLpP (HCILP =3D host channel ID Lun Partition)
is also provided.

http://www.suse.de/~garloff/linux/scsi-many/

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--nbhonbzV/xpXxmuC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2-rc1-SuSE (GNU/Linux)

iD8DBQE/DG8YxmLh6hyYd04RApRAAJ4o5vgEnW0qwBD06Jm5ocP1vFfxogCfR7q9
NP4MK7Ok7BWz/RV3kgVIa9g=
=PpOx
-----END PGP SIGNATURE-----

--nbhonbzV/xpXxmuC--

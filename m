From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: status question - IP over FC for qla2xxx?
Date: Fri, 8 Sep 2006 23:49:16 -0700
Message-ID: <20060909064916.GF12098@curie-int.orbis-terrarum.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ChQOR20MqfxkMJg9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.isohunt.com ([69.64.61.20]:62169 "EHLO mail.isohunt.com")
	by vger.kernel.org with ESMTP id S932325AbWIIGSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Sep 2006 02:18:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--ChQOR20MqfxkMJg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm trying to establish the status of IPFC (IP over Fibre Channel) for
the qla2xxx driver (and the QLA2312 chip in my specific deployment).

Researching it, I see that there were some patchsets way back in the
2.4.20 days (http://ftp.parisc-linux.org/patches/diff-2.4.20-pa31), but
I find nothing modern, nor any record of why it was ripped out.

The kernel and -scsi mailing list archives don't even mention IPFC.

This is maybe a question better directed at the network mailing lists,
but I'm reasonably certain that Ravi Anand and some of the others from
Qlogic hang out here.

I'm not after IPFC for high bandwidth, just the ability to check
connectivity without having the HBA binary libraries (my test platform
has them available, but I don't have that luxury further down the line).

While I'm at it, how's the IP support for other cards? I'm already
committed to Qlogic here, but I'd appreciate it for future design
choices.

--=20
Robin Hugh Johnson
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--ChQOR20MqfxkMJg9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks

iD8DBQFFAmPsPpIsIjIzwiwRAinqAKDqQoy1Pd5RzN0Jd6HqMpYC1jdn/gCfXa5v
BdVs9kouex0W8yxIvSgNaIU=
=hiHS
-----END PGP SIGNATURE-----

--ChQOR20MqfxkMJg9--

From: Ryan Anderson <ryan@autoweb.net>
Subject: aacraid on Dell PE 2650
Date: Tue, 19 Oct 2004 09:30:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098192600.22753.554.camel@ryan2.internal.autoweb.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-opTfT+F/Ty+VD3HHUDYf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:16646 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S269398AbUJSNaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 09:30:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: markh@osdl.org, aacraid@adaptec.com


--=-opTfT+F/Ty+VD3HHUDYf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm having some problems that I hope you can help with, or at least,
suggest a workaround that may make the problem go away.

I'm not on linux-scsi so please cc: me on all replies, please.

I've got a PowerEdge 2650 running the 2.6.8 kernel (source from the
Debian tree, I don't think there's anything substantial different
between it and 2.6.8.1 in this area.)

In short, I'm seeing a variety of drive related lockups.

The latest one referred to the drive being "offline" (I forgot to write
the exact error down, but I recall that word precisely)

None of the drives appear to be failed, as far as the controller is
concerned, and a simple reboot fixes the problem temporarily.

I'm seeing about a problem every 1.5 - 2 weeks at the moment, so it's a
bit hard to debug (and everytime it fails it creates a panic situation.)

It happened today for the 3rd time, all three have been while the
machine is under a decent amount of load.

Any assistance you can provide would be greatly appreciated.


--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20

--=-opTfT+F/Ty+VD3HHUDYf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBdRbYvV/uNaz8d+gRAiM5AJ9dO2jL9s5hdRABro9yy81aUALjKwCfX9MW
GgDf5pPvGWS1rVGV57u9ge4=
=p9tb
-----END PGP SIGNATURE-----

--=-opTfT+F/Ty+VD3HHUDYf--

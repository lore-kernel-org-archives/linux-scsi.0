From: Ben Hutchings <ben@decadent.org.uk>
Subject: ipr driver fails to build for 32-bit powerpc
Date: Mon, 07 Jun 2010 01:51:21 +0100
Message-ID: <1275871881.10677.81.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-K5rl9O2mo4F+ICttGpOp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52425 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab0FGAv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2010 20:51:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-K5rl9O2mo4F+ICttGpOp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

SCSI_IPR depends only on PCI && SCSI && ATA, but ipr.c now uses writeq()
which is not defined for all architectures.  This is a regression from
Linux 2.6.33.

If the sis64 hardware can be driven using 32-bit MMIO then please define
writeq() in terms of writel() where the writeq macro is not defined.
Otherwise, please make the sis64 support conditional.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-K5rl9O2mo4F+ICttGpOp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATAxChOe/yOyVhhEJAQJnjg/+NiBAqlJVRE00GJLGf9FYefV65L5rNPxa
yFz8K2BEBRPqdF2+7jZkgD1o6dAoz8uxG18JU6urWnHadBh1C48M+7V9BlG/Tw5l
d0ipUPGC7/14fMvAhYDrBkznTjG0QtvP5Q+yPNmkfXqi0r0vs8xrq2y0SoOZzsBX
HVKLnbt8i+gJuHS4ozUicI8ehWWN//tAFhPnT+wRKrWtM7dLLMc8z6D+I2+46DqZ
peURkG+SVWkwmX35IuDZja+FdKwPcSpqRJ1Y4AqrUwf/jec7e8FvIZDVP+2r1lfd
N9n5gVnXQdN+fMW8Ig6UI9LJpqztIbL0PgJgcy/eLZwpLuN9FElOK3ecdTFxDyNi
iX977CRMtNOlXqHLbisEeamQ/Nkmy1AJNNHsClcH4r/H+g/hKQiPGeNHn0ihyIao
fDPc04NboT+5RN7U+/loKD3XOVnoNPWXei0wzy9zWyRDPJz++ijCc36g2FzjEX3x
zCHHQNgvxrBOU0OfTPHPp5XUCxUB75YAMjrp9FFfnfe2k2IAhn2qDhpQnHbhJClm
+bM/NH1VnIEC/A4774seQOYrtb5bDBjhS4jtDvHg8o0tztrO3FZ3YWhzDarf7Txv
OWWhBLymIabztRlSqFDghozwmFxhYNxxrH7Lr9YQs97G06rZYzELoE4++59oC1l9
AfwIXHSMXkQ=
=u53O
-----END PGP SIGNATURE-----

--=-K5rl9O2mo4F+ICttGpOp--

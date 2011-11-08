From: Ben Hutchings <ben@decadent.org.uk>
Subject: mptspi init failure on Sparc SMP in Linux 3.0
Date: Tue, 08 Nov 2011 03:05:18 +0000
Message-ID: <1320721518.18929.15.camel@deadeye>
References: <4EB7D137.7090903@univ.rzeszow.pl>
	 <20111107205409.GG3366@decadent.org.uk> <4EB858E8.6090304@univ.rzeszow.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zMXiEezTQSmZ+B8Hq9Rr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58438 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab1KHDFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2011 22:05:44 -0500
In-Reply-To: <4EB858E8.6090304@univ.rzeszow.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: Biblioteka UR <biblio@univ.rzeszow.pl>, 647900@bugs.debian.org, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPTFusionLinux@lsi.com


--=-zMXiEezTQSmZ+B8Hq9Rr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mariusz at Biblioteka UR reports this failure in a new Debian
installation on a SunFire v490 system:

> [    0.000000] Linux version 3.0.0-1-sparc64-smp (Debian 3.0.0-3) (ben@de=
cadent.org.uk) (gcc version 4.5.3 (Debian 4.5.3-8) ) #1 SMP Sat Aug 27 19:5=
1:14 UTC 20
[...]
> [   52.190433] Fusion MPT base driver 3.04.19
> [   52.238528] Copyright (c) 1999-2008 LSI Corporation
[...]
> [   52.370161] Fusion MPT SPI Host driver 3.04.19
> [   52.370364] mptbase: ioc0: Initiating bringup
[...]
> [   52.847504] ioc0: LSI53C1030 C0: Capabilities=3D{Initiator,Target}
[...]
> [   68.319518] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [   69.175505] mptbase: ioc0: Attempting Retry Config request type 0x3, p=
age 0x, action 0
> [   84.267524] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [   84.364482] mptbase: ioc0: Initiating recovery
> [   90.299505] mptbase: ioc0: Attempting Retry Config request type 0x3, p=
age 0x, action 0
> [  105.391523] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [  105.488509] mptbase: ioc0: Initiating recovery
> [  126.527516] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [  127.383505] mptbase: ioc0: Attempting Retry Config request type 0x4, p=
age 0x1, action 0
> [  142.475528] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [  142.572504] mptbase: ioc0: Initiating recovery
> [  148.611505] mptbase: ioc0: Attempting Retry Config request type 0x4, p=
age 0x1, action 0
> [  163.703482] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, =
doorbell=3D0x24000000
> [  163.800495] mptbase: ioc0: Initiating recovery

(I think there are some characters missing in the above log,
particularly the page numbers.)

However, the driver apparently works on the same system in a !SMP kernel
configuration.

The complete report can be found at <http://bugs.debian.org/647900>.
Can you suggest any way to correct or debug this problem?

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-zMXiEezTQSmZ+B8Hq9Rr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATricbue/yOyVhhEJAQpySRAAk5uUQ+SpXsz1YybIYHnO6Kh79x/LelfK
3mjlBzIFJ74mrIxyyXaxtJDNV73iaVdUPTG8LHMZQlccYuRuIvn+GpZ7M1pL4UN9
m3zKanD+tmMCcVDpdfE5jewtUxFdlM3Qkjy3NkD/ngTmx9rwlZ+/Sxo//DdsWvXV
Uxv9cjOMCqHHr3O1NRMYuhhqPsjSNOze6E5hVhbDvZQlRQ/ycnTGSUelwnnyXmB+
tcMQwnWKoA8xFFUItgfScgr8sRGZMJszdTxxmLLNNxabv8ZNHeGaaTqjnNEpG8/9
EtHzyiBVi7mjka7QEdVWLvNheudGmPkz+H5NX8zLzr89Wqt1fJHWlKBWCnjPRET0
XwAX5/esi0WS35a7AD8ttb6gWTx8reB7tnyQxpJFT/9VYN6bgOmb6g35qKu0yGin
cU6yfRhS+63lCONGLuEB1dJQYONC4s00GHS/WXE92iWgfSfiD4TP9DFfXpmhGaRR
rqhVMmBfz/9RYQ/T7T7ds2eDl2i52swyC9d9N7vIzxxaBlJynBPzE9HJ16Z4hNiQ
TekeXKIufwoEgc51x24s/bA6GWjPj3wHpCtz/YEUcK4pisplhHjTycKKiZ2mveqO
a3Q35tbU0bx126QJW97o4x0puAn5r0N4gk0gfhd8385Dhs7vaLm6bkm1WrOCAk1I
xpxz7ZqLFB4=
=Vx3B
-----END PGP SIGNATURE-----

--=-zMXiEezTQSmZ+B8Hq9Rr--

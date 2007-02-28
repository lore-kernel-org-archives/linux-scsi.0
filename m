From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Wed, 28 Feb 2007 16:37:22 +0100
Message-ID: <20070228153722.GJ22572@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:45116 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbXB1Phe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 10:37:34 -0500
Content-Disposition: inline
In-Reply-To: <20070228151829.GI22572@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 16:18, Andre Noll wrote:

> With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> writing to both raid systems at the same time via lvm still locks up
> the system within minutes.

Screenshot of the resulting kernel panic:

	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png

Andre

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF5aGyWto1QDEAkw8RAr33AKCcCEmhjWp2laq+fOrRKA+8+guuGwCgljar
0a+Mc5A0aQ9vj1UyLlxsejQ=
=k2MA
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--

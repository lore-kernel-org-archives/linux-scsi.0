From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Thu, 8 Mar 2007 10:33:31 +0100
Message-ID: <20070308093331.GC4252@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk> <20070308085209.GB4252@skl-net.de> <20070308090247.GB9671@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:40592 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413AbXCHJdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2007 04:33:45 -0500
Content-Disposition: inline
In-Reply-To: <20070308090247.GB9671@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:02, Jens Axboe wrote:
> Do you still have the vmlinux? It'd be interesting to see what
>=20
> $ gbd vmlinux
> (gdb) l *cfq_dispatch_insert+0x28
>=20
> says,=20

The vmlinux in the kernel dir is dated March 5 and my bug report
was Feb 28. So I'm afraid it's gone. I tried the gdb command anyway
but it only gave me

	No symbol table is loaded.  Use the "file" command.

Sorry
Andre

--=20
The only person who always got his work done by Friday was Robinson Crusoe

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF79hrWto1QDEAkw8RAudkAJ4gtJjd77eWBTzL4+MPnvFfFrVbBgCfeRbs
c99EETn6riyLdbAfGHYzZNw=
=aySe
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--

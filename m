From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Wed, 28 Feb 2007 16:18:29 +0100
Message-ID: <20070228151829.GI22572@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:44759 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbXB1PSm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 10:18:42 -0500
Content-Disposition: inline
In-Reply-To: <20070227185134.GJ20397@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:51, Andrew Vasquez wrote:
> On Tue, 27 Feb 2007, Andre Noll wrote:
> > [   68.532665] BUG: at kernel/lockdep.c:1860 trace_hardirqs_on()
>=20
> Ok, since 2.6.20, there been a patch added to qla2xxx which drops the
> spin_unlock_irq() call while attempting to ramp-up the queue-depth:
>=20
> Could you try the latest 2.6.21-rc which contains the correction?

With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
writing to both raid systems at the same time via lvm still locks up
the system within minutes.

As lockdep revealed another dm-related lock problem on this kernel,
I guess I'll have to bother the lvm people on this.

Thanks
Andre

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF5Z1FWto1QDEAkw8RAoC4AJ0TWmP8BO8mC5YjwKbKqeslRTY1CwCfYOSM
maZi/OoYRys9tZ75BEB3GHc=
=GKfy
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--

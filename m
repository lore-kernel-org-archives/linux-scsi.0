From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: pulling failover out of qla2xxx
Date: Sun, 18 Jan 2004 11:37:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074422254.4428.3.camel@laptop.fenrus.com>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
	 <40084860.90902@pobox.com> <20040117205230.GB8301@praka.local.home>
	 <1074373727.4429.4.camel@laptop.fenrus.com>
	 <20040117215203.GA9041@praka.local.home>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kpQC9lpvVTD/m2n2LCDV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:28544 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S266314AbUARKhy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 05:37:54 -0500
In-Reply-To: <20040117215203.GA9041@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>


--=-kpQC9lpvVTD/m2n2LCDV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2004-01-17 at 22:52, Andrew Vasquez wrote:

> I'll just throw this out, if in fact as you say request_firmware()
> won't work with the current initrd's used by the distros then perhaps
> we could simply build the firmware images as modules (minus the
> per-firmware loader) and have a generic qlafc.ko (or whatever the name
> you'd like) loader that the user would modprobe. The qlafc driver
> would then register the pci_device_id tables for all ISP chips and
> wait for the pci_driver callback to signify which firmwares modules to
> load.  Load the firmware, call probe(), then move on. =20

this breaks those initrd's just as much.
The current approach actually is pretty clean (module dependencies pull
everything in etc etc) and I *really* don't see the objection to it.
Sure the request_firmware() interface is nicer but it's not like having
the a few frontend modules is actually a problem; all distros just do
the right thing with these, even for custom compiled kernels.=20


--=-kpQC9lpvVTD/m2n2LCDV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBACmHuxULwo51rQBIRAg1lAJ9Ig6I1iwl9LllhzhX1nUmFWdc5OwCfTphU
trhEm+i9VNH2GmbgTlVg2gA=
=mRP4
-----END PGP SIGNATURE-----

--=-kpQC9lpvVTD/m2n2LCDV--

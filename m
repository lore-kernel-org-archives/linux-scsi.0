From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 27 Feb 2007 15:35:42 +0100
Message-ID: <20070227143542.GB22572@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:55574 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXB0Of6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Feb 2007 09:35:58 -0500
Content-Disposition: inline
In-Reply-To: <20070227101100.GA22572@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:11, Andre Noll wrote:
> On 10:26, Andrew Vasquez wrote:
> > You are loading some stale firmware that's left over on the card --
> > I'm not even sure what 4.00.70 is, as the latest release firmware is
> > 4.00.27.
>=20
> That's the firmware which came with the card. Anyway, I just upgraded
> the firmware, but the bug remains.

the system crashed again btw., this time resulting in a kernel panic
instead of just locking up silently. Here's a screenshot:

	http://systemlinux.org/~maan/shots/qla2xxx-crash-huangho2.png

Regards
Andre

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF5EG+Wto1QDEAkw8RAiMZAJwIWizXYpnKdJjpsz8WJkQ+0m2hWACgm+5n
i8gQLsLPPGSpNp/H0paJs5E=
=476e
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--

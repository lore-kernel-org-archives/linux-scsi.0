From: florin@iucha.net (Florin Iucha)
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 16:44:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516214412.GF11884@iucha.net>
References: <20030516190414.GD11884@iucha.net> <Pine.LNX.4.44L0.0305161715250.1555-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iucha.net ([209.98.146.184]:20600 "EHLO mail.iucha.net")
	by vger.kernel.org with ESMTP id S264610AbTEPVbU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 17:31:20 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0305161715250.1555-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 05:23:59PM -0400, Alan Stern wrote:
> Good.  This clearly shows the problem.  It's an error in the SCSI driver.=
 =20
> It has shown up before and been discussed at length a few weeks ago.  The
> problem is that a MODE-SENSE(6) command is requesting a transfer of 3
> bytes, which is smaller than the minimum of 4 bytes for that command. =20
> The device doesn't like it and crashes.
>=20
> The SCSI people are supposed to be working on this.  First, we should be=
=20
> using MODE-SENSE(10) by default rather than MODE-SENSE(6).  Second, we=20
> should never request a transfer smaller than the minimum allowed size. =
=20
> When these changes are ready you shouldn't have any more trouble.
>=20
> The OOPS you got originally was caused by the lack of proper=20
> hot-unplugging cooperation between usb-storage and the SCSI driver.

At GregKH's suggestion I have opened a bug in 'zilla:
   http://bugme.osdl.org/show_bug.cgi?id=3D724
You might want to update it or close it.

Thank you,
florin

--=20

"NT is to UNIX what a doughnut is to a particle accelerator."

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+xVusNLPgdTuQ3+QRAt8PAKCTNvR20LqoiD2Rdu75ebu5zH+phwCeLn7N
g9apPKFFpn1NDB5vAUwTBME=
=QIoB
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--

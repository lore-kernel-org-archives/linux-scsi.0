From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:46:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030621174640.M2811@one-eyed-alien.net>
References: <20030621165920.F2811@one-eyed-alien.net> <1056241551.1775.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="8c07nsHwQobhlezh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:48145 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264934AbTFVAci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:32:38 -0400
Content-Disposition: inline
In-Reply-To: <1056241551.1775.14.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Jun 21, 2003 at 07:25:49PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


--8c07nsHwQobhlezh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2003 at 07:25:49PM -0500, James Bottomley wrote:
> What probably should happen is that the resetting of the flag should be
> in scsi_io_completion (like it is for the use_10_for_rw flag), then the
> retry and the flag reset would come for free.

Since you seem to have a handle on this, can you fix it?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--8c07nsHwQobhlezh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+9PxwIjReC7bSPZARAjl/AJ4pSGlYQcdxVYbkKer/A6ZH5IuTJQCgkRpv
gHd+8QNvqNHAYeqO1Q3+KvM=
=Kodb
-----END PGP SIGNATURE-----

--8c07nsHwQobhlezh--

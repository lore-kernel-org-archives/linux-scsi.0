From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 17:23:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629172341.C4728@one-eyed-alien.net>
References: <3EFE8784.4000101@pobox.com> <20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com> <20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com> <20030629110205.A4728@one-eyed-alien.net> <3EFF2D45.1040203@pobox.com> <1056911816.10896.207.camel@mulgrave> <3EFF38DF.2030502@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:49417 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265522AbTF3AJ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 20:09:26 -0400
Content-Disposition: inline
In-Reply-To: <3EFF38DF.2030502@pobox.com>; from jgarzik@pobox.com on Sun, Jun 29, 2003 at 03:07:11PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andries Brouwer <aebr@win.tue.nl>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 03:07:11PM -0400, Jeff Garzik wrote:
> sr.c is still hardcoded to use mode_sense_6...  even though it's been=20
> hardcoded to use read/write_10 for years :)

James made a patch to fix this, which I intend to test today or tomorrow.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+/4MNIjReC7bSPZARAiJZAJ99ee+uuUHHJeSMEKr4tlIIxwzmDACeMWiK
vzE54EKBhOXC+Q8++6IjtLE=
=ZKc9
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--

From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: scsi mode sense broken again
Date: Thu, 3 Jul 2003 17:10:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030703171053.A3254@one-eyed-alien.net>
References: <UTC200307032306.h63N6HQ26283.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:43793 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265528AbTGCX4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 19:56:30 -0400
Content-Disposition: inline
In-Reply-To: <UTC200307032306.h63N6HQ26283.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Fri, Jul 04, 2003 at 01:06:17AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2003 at 01:06:17AM +0200, Andries.Brouwer@cwi.nl wrote:
> For me 2.5.72 works, 2.5.74 does not - no working ZIP drive.
> The cause is the recent fiddling of use_10 / do_mode_sense.
> If this is known and has a patch on the way all is well.
> Otherwise I can send a patch.

Really?  I expected bug reports for CD-ROM, but not for Direct Access
devices.  What's going bad?

> (It feels as if I have to repair this area every other month.)

That's why I originally wanted to just filter all MODE_SENSE commands from
the USB layer.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/BMYNIjReC7bSPZARAn05AKCEaDNeui4ou5uU++IM47GPu4V3zgCeMp2D
bEOIqpHOlQE0r1qJ3eC+DOA=
=jG81
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

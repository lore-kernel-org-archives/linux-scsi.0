From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] definitive abstraction of the mode_sense commands
Date: Tue, 24 Jun 2003 01:17:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624011735.B13924@one-eyed-alien.net>
References: <1056429111.2887.173.camel@mulgrave> <3EF80775.9020105@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:35077 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264912AbTFXIDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 04:03:31 -0400
Content-Disposition: inline
In-Reply-To: <3EF80775.9020105@torque.net>; from dougg@torque.net on Tue, Jun 24, 2003 at 06:10:29PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2003 at 06:10:29PM +1000, Douglas Gilbert wrote:
> For really depraved devices it can be useful to send a
> MODE SENSE(6 or 10) that only asks for a 4 byte response. From
> this response the length of the respone that can be supplied
> is deduced. Then a second MODE SENSE can be
> issued for the now known response length. Yes, it's
> horrible, but that is precisely what Joerg Schilling
> does in cdrecord.
> Your code seems to have this technique in mind but requires
> a MODE SENSE(10) response buffer to be at least 8 bytes long.

The code does it this way because more devices seem to work that way.  That
is, always ask for the 'header' size as a minimum, and header size depends
on which command you send.

Lots of devices can't return less than the header size.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE++AkfIjReC7bSPZARAreUAKCERrrqVei+g1yzW6lEM/CrZY+aGwCeOD6+
2XTo0FUQb5SasBSN8Tj/kkg=
=3ccE
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--

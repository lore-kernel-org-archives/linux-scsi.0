From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Fri, 14 Nov 2003 09:29:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031114092913.A19467@one-eyed-alien.net>
References: <1068767049.2851.166.camel@patrh9> <Pine.LNX.4.44L0.0311141058290.1090-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:9489 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262795AbTKNR3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:29:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311141058290.1090-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Nov 14, 2003 at 11:14:08AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 11:14:08AM -0500, Alan Stern wrote:
> Unfortunately that does mean we lose the ability to tell if a compliant
> device/media is write-protected.  You suggested allowing MODE-SENSE
> commands for devices that present certain standard SubClass and Protocol
> values, or disallowing them only for devices that present vendor-specific
> values.  I'm not so sure that will work -- I haven't kept good records of
> users' reports, but it wouldn't be at all surprising to find that some
> apparently-compliant devices (bInterfaceSubClass =3D x06, Protocol =3D x5=
0)
> still have problems with MODE-SENSE.

I _know_ that some 'apparently-compliant' devices have trouble with
MODE_SENSE.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tRDpIjReC7bSPZARAtm2AJ0eKW9hTdM2Ip2OsblGMT++FOxdiQCg0Les
8+Jb9H8FkKxNDQhbiQRi3jQ=
=DNtg
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--

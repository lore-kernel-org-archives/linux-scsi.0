From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass	larger receive buffer
Date: Thu, 13 Nov 2003 18:19:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113181945.I30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068767049.2851.166.camel@patrh9> <1068768796.3fb41e1c8d075@webmail.netregistry.net> <1068775834.2851.321.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="cf0hFtnykp6aONGL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:41735 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264501AbTKNCTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:19:50 -0500
Content-Disposition: inline
In-Reply-To: <1068775834.2851.321.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 07:10:34PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dmitrik@users.sourceforge.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org


--cf0hFtnykp6aONGL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 07:10:34PM -0700, Pat LaVarre wrote:
> Can we blacklist mode sense from bInterfaceSubClass =3D xFF?
>=20
> That way we don't break as many write-protectable devices as if we
> blacklisted mode sense always?
>=20
> I remember today already I once proposed blacklisting only
> bInterfaceSubClass =3D xFF, Matt said no once, I don't think I yet grok
> Matt's no.
>=20
> Can we blacklist only xFF if I wrote the patch myself?

Perhaps I didn't understand what you were asking....

To blacklist bInterfaceSubClass =3D 0xFF, you'll have to do that at the
usb-storage layer (not the SCSI layer).  I generally object to that, but
not very strongly -- I want usb-storage to be as simple/dumb as possible,
to reduce to number of places where it doesn't do what the end-user
expects.  (The principle of least suprise)

If the blacklist was implemented such that it only blacklisted
direct-access devices, and only MODE_SENSE and MODE_SENSE_10, and provided
fake sense data, then it would probably work.  Messy, but it would work.

The point is to create as narrow an exception as possible.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Umm, these aren't the droids you're looking for.
					-- Bill Gates
User Friendly, 11/14/1998

--cf0hFtnykp6aONGL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tDvBIjReC7bSPZARAgu4AKCw9B+0zvEm6ZemQLY2/3yrV7idNwCeN6+D
5wrnNfVcJfScjaczoiZvRuw=
=q0vJ
-----END PGP SIGNATURE-----

--cf0hFtnykp6aONGL--

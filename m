From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 23 Mar 2003 17:37:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323173733.B24668@one-eyed-alien.net>
References: <20030322193705.C17056@one-eyed-alien.net> <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048467235.1634.22.camel@mulgrave>; from James.Bottomley@steeleye.com on Sun, Mar 23, 2003 at 07:26:09PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 23, 2003 at 07:26:09PM -0600, James Bottomley wrote:
> The problem with this type of approach is that there's no unified list
> of "known good" commands that actually let you operate a device.  The
> SCSI and ATAPI standards have been gradually deprecating the commands
> that SCSI-1 (and sometimes even SCSI-2) regard as mandatory
> (READ_6/WRITE_6 springs to mind).

Actually, there is such a list.  It's the commands that the 'popular OS'
uses, and I have a pretty good idea exactly what those are.  That's why my
original approach was to just cut out the commands that fell outside that
definition.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I want my GPFs!!!
					-- Stef
User Friendly, 11/9/1998

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+fmFdIjReC7bSPZARArUSAJ4q0CJI3YsdF0cnxVvVLb7wyNotZgCgnA7X
jhGXrIBKbtqMMXoJwFCve6s=
=AfeL
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] mode sense blacklist how
Date: Thu, 13 Nov 2003 18:44:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113184430.A6579@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068767049.2851.166.camel@patrh9> <1068768796.3fb41e1c8d075@webmail.netregistry.net> <1068775834.2851.321.camel@patrh9> <20031113181945.I30194@one-eyed-alien.net> <1068777510.2851.359.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:18952 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261950AbTKNCod (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:44:33 -0500
Content-Disposition: inline
In-Reply-To: <1068777510.2851.359.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 07:38:30PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, dmitrik@users.sourceforge.net, stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 07:38:30PM -0700, Pat LaVarre wrote:
> Ouch, one last thing: tell me again what device/interface descriptors
> our usb-storage by default tries to support?
>=20
> Is that bInterfaceClass ...SubClass ...Protocol =3D x 08 XX (00|01|50)?=
=20
> Or just x 08 (00..06|FF) (00|01|50)?  (Clearly it's not just the
> formally defined x 08 (00..06) (00|01|50).)

We support x 08 (00..06) (00|01|50).) plus whatever is listed in the
unusual_devs.h file.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Let me guess, you started on the 'net with AOL, right?
C:  WOW! d00d! U r leet!
					-- Greg and Customer=20
User Friendly, 2/12/1999

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tEGOIjReC7bSPZARAhUcAKCWx7jiYeSiW6u9XrLlr51PX3PerQCgsOK9
xfkCqfkYvETtRsFHUvR4cU4=
=vhKh
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--

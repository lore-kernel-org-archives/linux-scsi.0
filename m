From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 21:34:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424213420.A18145@one-eyed-alien.net>
References: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl> <20030424191238.E10511@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:18956 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262945AbTDYEWX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 00:22:23 -0400
Content-Disposition: inline
In-Reply-To: <20030424191238.E10511@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Thu, Apr 24, 2003 at 07:12:38PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com, stern@rowland.harvard.edu


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 07:12:38PM -0700, Matthew Dharm wrote:
> On Fri, Apr 25, 2003 at 02:43:25AM +0200, Andries.Brouwer@cwi.nl wrote:
> > Are there any objections against viewing sr_bufflen
> > as the amount of actually available buffer space
> > (and thus potentially different from the transferred amount)?
>=20
> YES!  I MOST DEFINITELY OBJECT!

Before anyone reads this the wrong way, I want to apologize for the
shouting.  It was brought on by a combination of high stress at work and
the feeling that I was going around for another turn on the merry-go-round.

That's not an excuse just an explanation.

But the point remains, changing the meaning of sr_bufflen will break
usb-storage.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--huq684BweRXVnRxX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qLrMIjReC7bSPZARAnnYAKCSYmHBOGnoKApvb8nesfQfOYoD9gCfTHuQ
SOtlQtNKjh6eQy7b+mCn31g=
=lX7V
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--

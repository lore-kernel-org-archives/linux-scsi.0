From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass	larger receive buffer
Date: Thu, 13 Nov 2003 17:13:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113171300.F30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068767049.2851.166.camel@patrh9> <1068768796.3fb41e1c8d075@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:8198 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S264482AbTKNBNG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 20:13:06 -0500
Content-Disposition: inline
In-Reply-To: <1068768796.3fb41e1c8d075@webmail.netregistry.net>; from dmitrik@users.sourceforge.net on Fri, Nov 14, 2003 at 11:13:16AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "patmans@us.ibm.com" <patmans@us.ibm.com>, "james.bottomley@steeleye.com" <james.bottomley@steeleye.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "usb-storage@one-eyed-alien.net" <usb-storage@one-eyed-alien.net>, "ronald@kuetemeier.com" <ronald@kuetemeier.com>, "idan@idanso.dyndns.org" <idan@idanso.dyndns.org>


--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2003 at 11:13:16AM +1100, Dmitri Katchalov wrote:
> IMHO the solution is either or both of:
> * Blacklist it
> * Define an absolute bare minimum safe subset of SCSI commands and=20
> fall back to it whenever you see a non-compliant device like this one.

How about:
	* Define an absolute bare minimum safe subset of SCSI commands and
	  use only those commands when communicating with a USB device.

Really, this is just a varient of blacklisting, but it's one I like.  I
suggested something like this a while ago -- if the emulated flag was set,
certain commands were not sent.  Linus didn't like that, but I think he
objected more to the 'emulated' flag than anything else.

Tho, I think we're basically at a point where the only problematic command
is MODE_SENSE and MODE_SENSE_10, so I say blacklisting them from USB
devices should be fine.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Money isn't everything, A.J.
AJ: Who convinced you of that?
G:  The Chief, at my last salary review.
					-- Mike and Greg
User Friendly, 11/3/1998

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tCwcIjReC7bSPZARAkaRAKCFvrViuYl6n5lYa9JC3WkOGggWsgCeJlMa
X5LPxgWEYzeuD+lFW6ghAkI=
=XxRa
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--

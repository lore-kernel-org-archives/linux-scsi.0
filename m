From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 17:06:28 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113170628.E30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068767049.2851.166.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:31493 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261947AbTKNBGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 20:06:35 -0500
Content-Disposition: inline
In-Reply-To: <1068767049.2851.166.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 04:44:09PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 04:44:09PM -0700, Pat LaVarre wrote:
> Alan S:
> > Those sound like different issues from the one we've been discussing in=
=20
> > this thread, namely: how should sd.c try to determine the read/write=20
> > status and cache-type of a disk device?
>=20
> I mean to be saying sd.c should by default send the CDB's associated
> with buffer lengths that produce the same BBB CBW's as Windows XP/2K,
> and then determine the read/write status and cache-type from that info
> alone.

I would go for this approach, but nobody has been able to figure out what
that CDB is.  There is even some suggestion that Win doesn't send any such
CDBs at all.

> I haven't yet seen a trace of Win XP/2K.

To my knowledge, nobody has.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tCqUIjReC7bSPZARArW7AKCmQFs+EnIuOUE5qYrH40Xmavxy7gCfTKcl
fpwX1Y99IjnmL05LFXM2lX8=
=QjQW
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--

From: Ryan Anderson <ryan@autoweb.net>
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600
	aacraid	PERC 3/Di Container goes offline
Date: Wed, 24 Nov 2004 13:35:58 -0500
Message-ID: <1101321358.26294.115.camel@ryan2.internal.autoweb.net>
References: <20041028005302.753a2d52.akpm@osdl.org>
	 <41A36CB7.16204.D3BCF639@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sM3eJPtCNy6vankox47l"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.autoweb.net ([198.172.237.26]:29968 "EHLO mail.autoweb.net")
	by vger.kernel.org with ESMTP id S262667AbUKXSg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2004 13:36:27 -0500
In-Reply-To: <41A36CB7.16204.D3BCF639@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andykinney@advantagecom.net
Cc: linux-scsi@vger.kernel.org


--=-sM3eJPtCNy6vankox47l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-23 at 17:00 -0800, Andrew Kinney wrote:
> I'll just add my two cents having gone through the exact same thing=20
> with a pair of PowerEdge 2500 systems with PERC 3/Di RAID=20
> controllers.  They both had the problem.

Thanks!

[snip]

> First, what enabled us to locate the problem was the following=20
> command run in the boot immediately following a crash.  It needs to=20
> be run from afacli after opening the controller.
>=20
> diagnostic show history /old

Ah, that helps.

I'm going to try like mad to get my system to fail again (it's rather
hard, oddly, but I was used to 10-day uptimes when this was in
production, so...)

Thanks for the tip, and I'll see what I can do to get a good diagnostic
out.

--=20

Ryan Anderson               =20
AutoWeb Communications, Inc.=20
email: ryan@autoweb.net=20

--=-sM3eJPtCNy6vankox47l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBpNSOvV/uNaz8d+gRAlVTAJ9yYhJ0tiOCDUzaikYMTwSTW3XsygCfclzs
RtOHtokHgSW7T2WRI1Pz4fU=
=adbP
-----END PGP SIGNATURE-----

--=-sM3eJPtCNy6vankox47l--

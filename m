From: "Robin H. Johnson" <robbat2@gentoo.org>
Subject: Re: status question - IP over FC for qla2xxx?
Date: Mon, 11 Sep 2006 17:54:12 -0700
Message-ID: <20060912005412.GD6819@curie-int.orbis-terrarum.net>
References: <20060909064916.GF12098@curie-int.orbis-terrarum.net> <19dce7c30609110429g2f112019lb6bc158213293808@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.isohunt.com ([69.64.61.20]:61571 "EHLO mail.isohunt.com")
	by vger.kernel.org with ESMTP id S965184AbWIKX43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 19:56:29 -0400
Content-Disposition: inline
In-Reply-To: <19dce7c30609110429g2f112019lb6bc158213293808@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: G Shyam Sundar <callshyam@gmail.com>
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, linux-scsi@vger.kernel.org


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2006 at 04:59:47PM +0530, G Shyam Sundar wrote:
>  The latest qlogic drivers(7.07.05 and 8.01.05) do support IP over FC
> for the 2 Gig Cards (so it should work in your case). The driver is
> not stable for the 4 Gig cards yet, and if you want to use a 4Gig card
> for IPFC, you may have to wait a bit longer. The 2 gig cards work
> pretty fine with this driver and I'd recommend that you try it out.
I did try the upstream qlogic driver briefly, but found it didn't seem
to do any of the sysfs stuff that I was expecting (/sys/class/fc_host
etc. so that I can use the issue_lip special file).

The in-kernel driver has the issue_lip file - but doesn't seem to have
the IPFC stuff?

Can I use the IPFC portion (qla2xip) with the in-kernel driver - or will
things break badly?

--=20
Robin Hugh Johnson
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks

iD8DBQFFBgU0PpIsIjIzwiwRAtgYAKDEOof8/wsFGMZPkMiYDUq4kGIM3wCfb4Lx
Q0gD9xLSbfPo+e/Ze0tnZ+Q=
=cuHg
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--

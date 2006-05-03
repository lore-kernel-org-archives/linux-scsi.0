From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: EMC Symmetrix vs. no storage on LUN 0
Date: Wed, 3 May 2006 09:09:34 +0200
Message-ID: <20060503070934.GA1109@bogon.ms20.nix>
References: <20060427091322.GA19126@bogon.ms20.nix> <20060428184555.GA4404@bogon.ms20.nix> <20060428195642.GA29753@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:25278 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S964995AbWECHXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 May 2006 03:23:05 -0400
Content-Disposition: inline
In-Reply-To: <20060428195642.GA29753@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 28, 2006 at 12:56:42PM -0700, Patrick Mansfield wrote:
> A similar patch is already in scsi-misc and mm trees, you should test one
> of those.
>=20
> Here is the patch from Kurt that was accepted into scsi-misc:
>=20
> http://www.kernel.org/git/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=
=3Dblobdiff;h=3D820c4ad7b5817e24550d50dd35ca740cd86de4fe;hp=3Df14945996ede5=
ec514bc0e390b506ffcfaa4d461;hb=3D4186ab1973758190916703eb8889ebe8002c5c8f;f=
=3Ddrivers/scsi/scsi_scan.c
Yes, seems that this is doing basically the same. Thanks!
 -- Guido

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEWFcun88szT8+ZCYRAuDvAJ0f7J883JSxEqy51eNE6gK0GX2sfwCZAQpi
oO7XoremffxcEDmHD98rQ04=
=pRsp
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--

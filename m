From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] scsi: RAID_ATTRS depends on SCSI
Date: Wed, 3 Mar 2010 17:17:20 +1100
Message-ID: <20100303171720.95a558b6.sfr@canb.auug.org.au>
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
	<4B7EC8AE.60200@oracle.com>
	<20100221194636.ef885e5a.rdunlap@xenotime.net>
	<1267594617.4383.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_17_17_20_+1100_6aF=io02THZmLivi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:52663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab0CCGRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Mar 2010 01:17:25 -0500
In-Reply-To: <1267594617.4383.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>

--Signature=_Wed__3_Mar_2010_17_17_20_+1100_6aF=io02THZmLivi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 03 Mar 2010 11:06:56 +0530 James Bottomley <James.Bottomley@suse.de=
> wrote:
>
> This will fix the error, but it's not quite the right thing to do.  the
> RAID class should be independent of SCSI, but it wants to do a SCSI
> check if SCSI is compiled in the matching routines.  This gives us a
> nasty dependency, the condition being that the raid class must be m if
> SCSI is m.
>=20
> I think this patch does the right thing.  Can someone test it on the
> config checker?  Or I can just put it in linux-next and have Stephen's
> builds do it.

My tree for today has Randy's fix in it.  Also, you should really test
against Linus' tree as that is where the problem currently lies.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_17_17_20_+1100_6aF=io02THZmLivi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuN/vAACgkQjjKRsyhoI8xjMwCeK4nQF/rU0yoffP9HOQ6gRW6F
wakAn2W7oeUecJ75oFsezHBhiLQhr5fL
=dOXd
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_17_17_20_+1100_6aF=io02THZmLivi--

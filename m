From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [origin tree build failure] Re: [PATCH -next] scsi: RAID_ATTRS
 depends on SCSI
Date: Wed, 3 Mar 2010 10:30:53 +1100
Message-ID: <20100303103053.7be411ba.sfr@canb.auug.org.au>
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
	<4B7EC8AE.60200@oracle.com>
	<20100221194636.ef885e5a.rdunlap@xenotime.net>
	<20100302112603.GA27686@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_10_30_53_+1100_OdGpE+XMTWUzZ4kS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:36415 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0CBXbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Mar 2010 18:31:00 -0500
In-Reply-To: <20100302112603.GA27686@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>

--Signature=_Wed__3_Mar_2010_10_30_53_+1100_OdGpE+XMTWUzZ4kS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 2 Mar 2010 12:26:03 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Randy Dunlap <rdunlap@xenotime.net> wrote:
>=20
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >=20
> > raid_class uses scsi interfaces, so it should depend on SCSI.
> > Otherwise build errors occur when RAID_ATTRS=3Dy and SCSI=3Dm:
> >=20
> > ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
> > ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
>=20
> FYI, this build bug has been pushed upstream via the SCSI tree, without=20
> Randy's fix.
>=20
> I have applied Randy's drivers/scsi/Kconfig fix to tip:out-of-tree and th=
at=20
> solves the build bug here.
>=20
>  Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks for the heads up Ingo, I have added that to my fixes tree as well
so it will be in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_10_30_53_+1100_OdGpE+XMTWUzZ4kS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuNn60ACgkQjjKRsyhoI8wlBwCfXSD3mJQSd9hYEgJ3wSq82zdG
W6AAnR5ShF5g0nBKHmaS0/MwetrInYkW
=39pg
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_10_30_53_+1100_OdGpE+XMTWUzZ4kS--

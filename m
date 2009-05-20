From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
Date: Thu, 21 May 2009 00:42:51 +1000
Message-ID: <20090521004251.9160e228.sfr@canb.auug.org.au>
References: <4A12797B.2060901@panasas.com>
	<4A12AC23.30808@panasas.com>
	<20090520111619.87f815b1.sfr@canb.auug.org.au>
	<1242830240.2881.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_May_2009_00_42_51_+1000_hLEKYZm01mEX/XkM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:32841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZETOm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 10:42:57 -0400
In-Reply-To: <1242830240.2881.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

--Signature=_Thu__21_May_2009_00_42_51_+1000_hLEKYZm01mEX/XkM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 20 May 2009 14:37:20 +0000 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Unfortuantely, I still need the block tree for-next to be rebased up to
> the current linus head because of a couple of conflicts:
>=20
> CONFLICT (content): Merge conflict in drivers/block/hd.c
> CONFLICT (content): Merge conflict in drivers/block/mg_disk.c

As discussed elsewhere, a merge of Linus' tree into the block tree will
fix this.

> So they obviously moved into linus head but wasn't taken out of block
> for-next.

Indeed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_May_2009_00_42_51_+1000_hLEKYZm01mEX/XkM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoUFusACgkQjjKRsyhoI8xs+ACghQT0ophu0F9SroxoRpAl0cKN
I8cAmwekYcZIVysJfEyY13uJNXeKZeFl
=vfRF
-----END PGP SIGNATURE-----

--Signature=_Thu__21_May_2009_00_42_51_+1000_hLEKYZm01mEX/XkM--

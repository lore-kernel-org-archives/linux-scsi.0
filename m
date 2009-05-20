From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
Date: Wed, 20 May 2009 11:16:19 +1000
Message-ID: <20090520111619.87f815b1.sfr@canb.auug.org.au>
References: <4A12797B.2060901@panasas.com>
	<4A12AC23.30808@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_May_2009_11_16_19_+1000_P9_=T03uHGqNtWl+"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:51804 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbZETBQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 21:16:27 -0400
In-Reply-To: <4A12AC23.30808@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

--Signature=_Wed__20_May_2009_11_16_19_+1000_P9_=T03uHGqNtWl+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
>=20
> This patch should be squashed into
>     [SCSI] FC Pass Thru support
>=20
> If it needs to compile after Tejun's block-layer revamps
> (all of them)

Is there some reason that the FC passthrough support (and any followup
patches) can't be pushed through the block tree.  It clearly currently
doesn't depend on anything new in the scsi tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_May_2009_11_16_19_+1000_P9_=T03uHGqNtWl+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoTWeMACgkQjjKRsyhoI8w99wCbBXNsAHv0QoVsPWNXdJPLjbt0
G5MAn2VRpxUYMxyubhtzCi069G2bXVRW
=CRIW
-----END PGP SIGNATURE-----

--Signature=_Wed__20_May_2009_11_16_19_+1000_P9_=T03uHGqNtWl+--

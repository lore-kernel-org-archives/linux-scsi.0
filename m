From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Thu, 14 May 2009 00:52:31 +1000
Message-ID: <20090514005231.506907f0.sfr@canb.auug.org.au>
References: <4A0307F4.50205@panasas.com>
	<20090512112539.GH4140@kernel.dk>
	<4A0AD8FA.6030903@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_May_2009_00_52_31_+1000_X_vVZUgYy44EtcVK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:35387 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbZEMOwn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 10:52:43 -0400
In-Reply-To: <4A0AD8FA.6030903@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

--Signature=_Thu__14_May_2009_00_52_31_+1000_X_vVZUgYy44EtcVK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Wed, 13 May 2009 17:28:10 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> I have done the rebase and ran some tests, however I was unable to test t=
hese patches
> as is, because there are some inter tree fallouts.
>=20
> Jens, James, Stephan, I please need your help
>=20
> The situation is like that.
> - Both block/for-next and scsi/master are based on an old osd upstream-po=
int (v2.6.30-rc3--ce8a7424)
> - Linus tip has important OSD patches that went in via scsi-rc-fixes whic=
h changed Wire format
> - If I try and merge block/for-next ontop of plain linus/master I get a m=
erge conflict
> - If I try merge scsi/master block/for-next I get build errors / conflicts
>=20
> So there is no sane tree point that I can test on.

We could ask Jens and James to both merge either Linus' tree or just the
scsi-rc-fixes tree into their trees.  Currently when I merge the scsi
tree I get only one very minor conflict.  The block tree, on the other
hand, had quite big problems today - but that was due to interactions
with the scsi tree.

If the above merges were done, then I suspect that the scsi tree with
commit 1bfe9caaff367601134c14fc428017419f628f7d ("[SCSI] FC Pass Thru
support") reverted would merge ok with the block tree and give you a base
for testing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_May_2009_00_52_31_+1000_X_vVZUgYy44EtcVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoK3q8ACgkQjjKRsyhoI8y9eQCeKy1FFd4a/9QcTTtdVfRV+SIZ
dRIAn2IxTw3xlSv2aYKDCPpyzSJas1Uq
=eofr
-----END PGP SIGNATURE-----

--Signature=_Thu__14_May_2009_00_52_31_+1000_X_vVZUgYy44EtcVK--

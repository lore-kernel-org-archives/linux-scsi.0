From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Tue, 11 Nov 2008 00:04:12 +1100
Message-ID: <20081111000412.b4bbaa51.sfr@canb.auug.org.au>
References: <48876009.8010701@panasas.com>
	<491073BB.4000900@panasas.com>
	<20081104111923.bb19c238.akpm@linux-foundation.org>
	<4916FAB3.4010409@panasas.com>
	<20081110102607.378c3279.sfr@canb.auug.org.au>
	<49182E85.9010405@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Nov_2008_00_04_12_+1100_fxsYjs8bxwLF/wBs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:33816 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYKJNEZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2008 08:04:25 -0500
In-Reply-To: <49182E85.9010405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>, linux-kernel@vger.kernel.org

--Signature=_Tue__11_Nov_2008_00_04_12_+1100_fxsYjs8bxwLF/wBs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Mon, 10 Nov 2008 14:52:21 +0200 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> This has proven itself already. I found some warnings on some ARCHs
> concerning printk of u64 types. I have made a sweep and fixed all these
> places and others.

Good.  That's partly what -next is for (to find the arch dependent
problems).

> If you could keep it for the next round it could be grate. So I can make
> sure I got rid of all the warnings.

Normally trees stay in linux-next until they are no longer needed
(usually at least until they have been integrated into Linus' tree) and I
automatically refetch the trees each day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Nov_2008_00_04_12_+1100_fxsYjs8bxwLF/wBs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkYMUwACgkQjjKRsyhoI8y9LgCcCimEtE9cNQrHI3suFGiHHsu1
f9UAoJBZoF4pqROGMRb5Fjibly2B3BFU
=oOYu
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Nov_2008_00_04_12_+1100_fxsYjs8bxwLF/wBs--

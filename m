From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Firmware patches for SCSI
Date: Mon, 22 Dec 2008 17:19:04 +1100
Message-ID: <20081222171904.b588da94.sfr@canb.auug.org.au>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
	<1229718543.18778.4.camel@localhost.localdomain>
	<3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
	<1229720031.18778.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Dec_2008_17_19_04_+1100_ZEvwn178rzHxmcZE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:41548 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYLVGTO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 01:19:14 -0500
In-Reply-To: <1229720031.18778.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jaswinder Singh <jaswinderlinux@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

--Signature=_Mon__22_Dec_2008_17_19_04_+1100_ZEvwn178rzHxmcZE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 19 Dec 2008 15:53:51 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> OK, then whatever tree contains them needs to eject them or be dropped
> from linux-next.

That is a problem for me and David.  Do not let it concern you ... :-)

> > So I am curious that should I resend these patches based on which git t=
ree.
>=20
> Yes please.  For me it would be against scsi-misc ... for the other
> drivers it would be their development tree.  The simplest thing to do is
> probably to rebase them all on top of linux-next (which contains all of
> our trees) and then send them to the individual subsystem maintainer
> lists.

Please don't do that, please base each one on either Linus' tree or the
appropriate maintainer's subsystem tree as linux-next is a moving
target (for instance, if you had based the scsi ones on next-20081219,
then the scsi tree was not included ...).  Basing on Linus' tree should
work in most cases as there are not to many conflicts caused by these
patches (the tg3 one is the worst so basing that off the net tree is
probably worth while).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Dec_2008_17_19_04_+1100_ZEvwn178rzHxmcZE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklPMVgACgkQjjKRsyhoI8x+XACghEIJur0rkOpT0QK4gPiU9gfX
s80AoLFsPbSqWqZhJwvmoSwO9plv7df2
=4hCL
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Dec_2008_17_19_04_+1100_ZEvwn178rzHxmcZE--

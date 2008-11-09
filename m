From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Mon, 10 Nov 2008 10:26:07 +1100
Message-ID: <20081110102607.378c3279.sfr@canb.auug.org.au>
References: <48876009.8010701@panasas.com>
	<491073BB.4000900@panasas.com>
	<20081104111923.bb19c238.akpm@linux-foundation.org>
	<4916FAB3.4010409@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Nov_2008_10_26_07_+1100_a2Z._j7.QHhcvrSg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:48351 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbYKIX0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2008 18:26:25 -0500
In-Reply-To: <4916FAB3.4010409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>, linux-kernel@vger.kernel.org

--Signature=_Mon__10_Nov_2008_10_26_07_+1100_a2Z._j7.QHhcvrSg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Sun, 09 Nov 2008 16:58:59 +0200 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> I have prepared a branch for linux-next based on today's Linus tree
> It is here:
>     git://git.open-osd.org/linux-open-osd.git linux-next
> This is if it's OK with James, as these bits are his responsibility.
> They need only sit in linux-next for a couple of weeks to get some wider
> compilation exposure. Other then that they are totally new code and
> are safe. Eventually they should be included into Linux-next through
> scsi-misc-2.6.

I have added that tree to linux-next for today.

What I say to everyone:  commits in that branch must have been posted
somewhere appropriate, reviewed, unit tested and destined for the next
merge window.  Also, note that my (new) practise is to temporarily drop a
tree if it causes non-trivial conflicts (especially with Linus' tree), so
don't be too upset if you get a message from me to that effect.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Nov_2008_10_26_07_+1100_a2Z._j7.QHhcvrSg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkXcY8ACgkQjjKRsyhoI8zqiwCgpQfbG13he3AXK2WXi24Atyg5
QkQAoLvKrU/ArrvIslvdS3J75rfQm2nX
=iwiW
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Nov_2008_10_26_07_+1100_a2Z._j7.QHhcvrSg--

From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Tue, 14 Oct 2008 10:44:59 +1100
Message-ID: <20081014104459.715fe7a2.sfr@canb.auug.org.au>
References: <1223909115.5566.13.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
	<1223925606.5566.20.camel@localhost.localdomain>
	<alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Oct_2008_10_44_59_+1100_Lg+tB609GdSff+pz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:57859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbYJMXpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 19:45:10 -0400
In-Reply-To: <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--Signature=_Tue__14_Oct_2008_10_44_59_+1100_Lg+tB609GdSff+pz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 13 Oct 2008 14:22:13 -0700 (PDT) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> Is linux-next coverage REALLY so weak that it doesn't even test the=20
> default config options, much less any random options? What's the point of=
=20
> linux-next then?

Check the results page of the automated builds I do
(http://kisskb.ellerman.id.au/linux-next) - I don't think that the
compile coverage is weak ...  Of course, if people don't read the
results ...

Those automated builds are done after the release.  Before the release,
the tree is built for ppc64_defconfig, powerpc allnoconfig, 44x_defconfig
for powerpc, allmodconfig for x86_64 and defconfig for i386, sparc and
sparc64.

All this is mentioned in my release notes every day.

> Again, the date on that thing is claimed to be September 19th, although i=
t=20
> was obviously committed later.

September 19 (Australian time) was the last linux-next release.  I don't
know off the top of my head if the particular patch in question was in
next-20080919, but it did contain a version of James' post merge patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Oct_2008_10_44_59_+1100_Lg+tB609GdSff+pz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjz3XsACgkQjjKRsyhoI8x2egCeNd/q0ntt6N/c9RKPwSe+x4jH
tIYAoIG0Oy5jnLKDIj/IFfdOgHdijTad
=cKY4
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Oct_2008_10_44_59_+1100_Lg+tB609GdSff+pz--

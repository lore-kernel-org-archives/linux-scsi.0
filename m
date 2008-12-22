From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Firmware patches for SCSI
Date: Tue, 23 Dec 2008 02:28:22 +1100
Message-ID: <20081223022822.0dd8aa66.sfr@canb.auug.org.au>
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
	<1229718543.18778.4.camel@localhost.localdomain>
	<3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
	<1229720031.18778.8.camel@localhost.localdomain>
	<20081222171904.b588da94.sfr@canb.auug.org.au>
	<494F4656.6010109@panasas.com>
	<1229958063.3345.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Dec_2008_02_28_22_+1100_SUCfyRkGPaXS.Auq"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:36410 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbYLVP2b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 10:28:31 -0500
In-Reply-To: <1229958063.3345.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jaswinder Singh <jaswinderlinux@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

--Signature=_Tue__23_Dec_2008_02_28_22_+1100_SUCfyRkGPaXS.Auq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Dec 2008 09:01:03 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> On Mon, 2008-12-22 at 09:48 +0200, Boaz Harrosh wrote:
> >=20
> > I think what James meant is to rebase over linux-next when cutting the
> > patches in order to send them to the different maintainers over email.
> > In that case linux-next is perfect because you are sure none of the
> > patches will conflict with any maintainer and you do that all in one
> > place. Since you are not merging then linux-next volatility does not
> > matter.

Unless there are conflict resolutions in the linux-next tree (and there
are a few) that involve the files in the generated patch.  In that case
the patch may not apply cleanly to any of the individual trees.

> The point is that it's hard to work out where all the maintainer trees

Hopefully you can glean that information from the MAINTAINERS file or the
Trees file in any linux-next tree (available via git-web if not from the
tree itself).

Just pointing out the possible problems ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Dec_2008_02_28_22_+1100_SUCfyRkGPaXS.Auq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklPshYACgkQjjKRsyhoI8z39wCeNBNhgeK3yjr5ZqRdzwOXUUpB
PzYAn23j+Hn2gVj1lJ5ETk9facpBlsRQ
=HUDa
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Dec_2008_02_28_22_+1100_SUCfyRkGPaXS.Auq--

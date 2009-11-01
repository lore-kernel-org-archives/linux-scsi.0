From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sun, 1 Nov 2009 22:52:56 +1100
Message-ID: <20091101225256.3aa2797e.sfr@canb.auug.org.au>
References: <20091031093337.GA3339@deprecation.cyrius.com>
	<4AED5FBF.6020308@panasas.com>
	<20091101105416.GN20819@deprecation.cyrius.com>
	<4AED7037.1080509@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__1_Nov_2009_22_52_56_+1100_wdXZP5M.qKSHyB9k"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:45798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZKALxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Nov 2009 06:53:03 -0500
In-Reply-To: <4AED7037.1080509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Martin Michlmayr <tbm@cyrius.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>

--Signature=_Sun__1_Nov_2009_22_52_56_+1100_wdXZP5M.qKSHyB9k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Sun, 01 Nov 2009 13:25:43 +0200 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> Yes I can see now linux/unaligned/le_byteshift.h and linux/unaligned/be_b=
yteshift.h look
> broken, they do not include headers who's definitions are used. All the o=
ther alternatives
> in linux/unaligned/ ,example access_ok.h, do. Sigh
>=20
> But one thing I do not understand, in linux-next is there not a single AR=
M platform that
> does a "make allmodconfig". (Or they do but the compilation error was nev=
er reported?)

The arm allmodconfig is really a non starter I am told (allmodconfig is
really per arch, not per platform).  However you can see all the
linux-next build results for arm (and lots of others) at
http://kisskb.ellerman.id.au/kisskb/branch/9/ .  I often don't have time
to review the build results - I assume that other people with an interest
will do so.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__1_Nov_2009_22_52_56_+1100_wdXZP5M.qKSHyB9k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrtdpgACgkQjjKRsyhoI8wWFgCgtvd3ta9X/OpvLhiB456uEBJk
If4AnidU5BBlTCgUv/quZtZ+RSrsIMdl
=dpDG
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Nov_2009_22_52_56_+1100_wdXZP5M.qKSHyB9k--

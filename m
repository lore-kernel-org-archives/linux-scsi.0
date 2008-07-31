From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [Bugme-new] [Bug 11185] New: Device/host RESET in SCSI
Date: Thu, 31 Jul 2008 17:32:42 +1000
Message-ID: <1217489562.1487.55.camel@localhost>
References: <bug-11185-10286@http.bugzilla.kernel.org/>
	 <20080730232409.81965504.akpm@linux-foundation.org>
	 <20080731072159.GB30534@parisc-linux.org>
Reply-To: michael@ellerman.id.au
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gbcjLm/evgTzEQPTNu4Q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:46775 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbYGaHco (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 03:32:44 -0400
In-Reply-To: <20080731072159.GB30534@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, cijoml@volny.cz, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org


--=-gbcjLm/evgTzEQPTNu4Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-31 at 01:21 -0600, Matthew Wilcox wrote:
> On Wed, Jul 30, 2008 at 11:24:09PM -0700, Andrew Morton wrote:
> > Why do you describe this regression as a powerpc problem rather than a
> > scsi one?
> >=20
> > (It could be either or both, I'm just wondering...)
>=20
> This seems quite astute of the reporter.  The error messages from sym2
> are consistent with an interrupt routing problem.=20

Hmm I suppose.

In that case can we see the full dmesg and a tarball
of /proc/device-tree from a working kernel, Cijoml?

Which begs the question what was the latest working kernel version?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-gbcjLm/evgTzEQPTNu4Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIkWqadSjSd0sB4dIRAlDeAJ9WZI6+Q+2zeJG1Fha2oVipE7AsnACdEEdr
kLrMnjJSWDOklwQvoMraVbU=
=5iws
-----END PGP SIGNATURE-----

--=-gbcjLm/evgTzEQPTNu4Q--


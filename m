From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#666108: megaraid_sas: which patches are needed for 2.6.32.y?
Date: Sun, 16 Dec 2012 23:24:50 +0000
Message-ID: <1355700290.18807.176.camel@deadeye.wl.decadent.org.uk>
References: <CAD2iGhWrruwSWtNo9pVH1Aufimq1W2G3VQKEHaWnmoXjnNk4cQ@mail.gmail.com>
	 <20121203144310.GA1357@elie.Belkin>
	 <CAD2iGhWegHsB+1P9unXn6sfveSQGFyahH9qKh4oHtXpxDSz1EA@mail.gmail.com>
	 <20121204062708.GA7633@elie.Belkin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2Lf8MnK23N4vp2pOSQYU"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab2LPXZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Dec 2012 18:25:12 -0500
In-Reply-To: <20121204062708.GA7633@elie.Belkin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>, 666108@bugs.debian.org
Cc: =?ISO-8859-1?Q?Torbj=F8rn?= Thorsen <torbjorn@trollweb.no>, Neela Syam Kolli <megaraidlinux@lsi.com>, adam radford <aradford@gmail.com>, linux-scsi@vger.kernel.org


--=-2Lf8MnK23N4vp2pOSQYU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-03 at 22:27 -0800, Jonathan Nieder wrote:
> tags 666108 - moreinfo
> quit
>=20
> Torbj=C3=B8rn Thorsen wrote:
>=20
> > The kernel boots with no problems, the storage controller seems to be
> > working nicely.
> >
> > root@xen14:~# dmesg | grep -i mega
> > [    3.340638] megasas: 00.00.05.38-rc1 Wed. May. 11 17:00:00 PDT 2011
> > [    3.340742] megasas: 0x1000:0x005b:0x1028:0x1f38: bus 3:slot 0:func =
0
>=20
> Yay, thanks much for checking.
>=20
> Ben and Dann, what do you think?  Should we apply these patches[1]?
>=20
> Regards,
> Jonathan
>=20
> [1] http://alioth.debian.org/~jrnieder-guest/temp/driver-test/megaraid-dr=
iver-backport.mbox

I've committed these, but we should really get some more users of both
old and new hardware to test the result.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-2Lf8MnK23N4vp2pOSQYU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUM5YQue/yOyVhhEJAQr/Ww//ZcR7GRYLFnMetRaGPp5sRa74Z7mFgfLT
F9ookPawUDNFX65bwGN7sLkzRFeC4bMv15CWrX5b253Vnl1AiRuvE3NHliAIOYDA
0OS5RVwN63EL+UaDADDoJyYH1kzHVGm4ATR1hz+wGjoblyv4YdC47fGaV+/NwFb/
FOPjEtAZtxcS8a6/fHhLQEfdxDpS6lUxl2mUMtuScqh/mp0pSsN4hUuOgnUn/7qx
Ux6Mm6IAKYAdUQJgYpQg0U4p/57rsCaJ4fttWSc3OC0Yuz70E6XUzLt1SkenyWaO
emY95ym5s1w9fd1rs1GD3l8WN5EdyTOZU1ePtQZrWXSjGEakzTzfSK4JcXE5fYAm
tzn3GF8iG+7EdsdmhjIzfvvpOT0UQ60J4a69RQVGL/LeX3JeJp/TBjUxu4hfkiGJ
kLeHEfCL7u9nrJ81VsArGGfaQTZfCljWYMalOzu22bQBvyntS/uJe2VmZyPY+bYL
roPmEpi34xYCr2QlwA/i1D8GhToEJuCREkpbGLGrQmxV/rKVmSS2DIZGOJtmFPYE
+HcWRXPFi0fb/cNTXxJm6sDZ4ww87JZzNjxfPrnXLRH/huO0G6LcXz5ZknI4EoPT
2v2uAyNeJNfSvqd9jCXkYrLmROYjeTl1gSkVF629nC9b2Rgto5XHO4kiA0aMq9x+
59G+xr3FHLA=
=A4mF
-----END PGP SIGNATURE-----

--=-2Lf8MnK23N4vp2pOSQYU--

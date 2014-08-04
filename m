From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Mon, 4 Aug 2014 21:39:02 +1000
Message-ID: <20140804213902.070f32a1@canb.auug.org.au>
References: <20140708134003.GA7790@infradead.org>
	<20140801122042.GA10771@infradead.org>
	<1406925121.2654.21.camel@jarvis>
	<20140804111147.GA29148@infradead.org>
	<20140804213059.32fd25d5@canb.auug.org.au>
	<20140804113404.GA11377@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aDy=zM=hbrVmTB/dtWAwXT+"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:49427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaHDLjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2014 07:39:09 -0400
In-Reply-To: <20140804113404.GA11377@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>

--Sig_/aDy=zM=hbrVmTB/dtWAwXT+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 4 Aug 2014 04:34:04 -0700 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Mon, Aug 04, 2014 at 09:30:59PM +1000, Stephen Rothwell wrote:
> > You realise that neither of these in linux-next as the scsi-core and
> > scsi-drivers trees had for-3.16 branches in the last round.  I assume I
> > should just drop these trees completely from linux-next?
>=20
> Well, they get pulled in through James, so you can drop them for now.

Will do.

> I mostly put you on Cc so you could comment wether there are any hard
> rules on how long even those simple fixes should be in linux-next.  I
> know you've put up stats for a few of the last merge windows about
> patches that weren't in linux-next, so there's been some tracking of it
> for sure.

If they are simple, clear fixes, then maybe a day or two just for build
coverage, but it is very much up to the maintainer.  There are always a
few poatches that get through late (quote a few of which I suspect have
been "in train", just not yet published in the maintainer's tree).

And, of course, real fixes go in just about anytime ...

I don't think we believe in hard rules for anything :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/aDy=zM=hbrVmTB/dtWAwXT+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT33DbAAoJEMDTa8Ir7ZwVsiwQAIs28kv/fhdztzi96vbYbER2
cbSkeseQHJ2ln3BCP44z8q0KYt8RKFneSoEhGkieIAqweaYfaZRicH3ZJVVCNALe
kdQkotxFynpiip0j01PfeEFs/Csjv++cPIWto29pxYXSCRhnKVs/iIqLYsi9odwp
5Syz6jzjyoJUs7gs+Cm48JVi1EbhNmwMfIxO/7j+lt50V7L5QmY2bYSP4HGFTAMX
/bnxm2Hv5ZuXe/d6gdxDyGMAFRHvjH4pV6GO5ENUUPyyop3KrDx73mV16p7s89ee
G3x9zHfmwxllUZrDC1D8QOxbKYOVsiYqnvdh2jmQBG+EHgYPG8eY6gzuzBu1HHph
zqBSqKSfljUyvuU0Pl7FHZzjUYn0vNyAOyCIxUu2yIjgroL3NxVeYrcUfGfiNUkb
GWKTI59FZhBX0b7cwmMgHBymOGeaOJd33NkFc5ZU6Xg37sBdTMkY9cMSZGC4vodc
xeekYIRWdbaHXqsogIkR2h246RGDhUGDerZzbUqfAUAJDSzUpdkvisxFFp2HfnEG
iPcSLY8O0sjluniYFDqxxG4C4LGKAAPcse6ExOunediI51plqo/H6PCN79XmVa+C
XCFqJ2vEYADAtkd3XV9mu1qExLvLAhebtkB5BMyoOTeGnvpCno/4g48PvbPetCg4
QFGYd92qB5OXwjeFxZDv
=GJUb
-----END PGP SIGNATURE-----

--Sig_/aDy=zM=hbrVmTB/dtWAwXT+--

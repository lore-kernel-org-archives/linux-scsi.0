From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Tue, 20 May 2014 10:03:43 +1000
Message-ID: <20140520100343.31490551@canb.auug.org.au>
References: <20140519140614.GA12183@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SA1utnxSaG3OjH0zuGrH_th"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140519140614.GA12183@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/SA1utnxSaG3OjH0zuGrH_th
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 19 May 2014 07:06:14 -0700 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> I'd like to announce the new scsi patch queue tree, which will pick up
> any scsi core or driver patches promptly to allow easy integration and
> feedback that contributors might be used to from other kernel subsystems.
>=20
> There are two branches, one for the SCSI core and upper level drivers,
> and one for low-level (hardware) drivers:
>=20
>   git://git.infradead.org/users/hch/scsi-queue.git core-for-3.16
>   git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.16=20
>=20
> The rules for the tree are:
>=20
>  - it has at least two positive reviews (non-author signoff, reviewed-by
>    or acked-by tags).   In practice this means it had at least one and
>    I added another one.
>  - no negative review on the mailing list
>  - it applies cleanly
>  - it compiles cleanly (drivers for architectures I can't test excluded)
>  - for core the core branch: survives a full xfstests run
>=20
> I went through the linux-scsi archives for March, April and May and
> applied all patches that clearly fit the above criteria, but it's fairly
> like I missed some.
>=20
> If I'm missing your patch(es):
>=20
>  - resend it unless it was sent in the last few weeks
>  - make sure all reviews are recorded in the most recent post of the
>    patch(es)
>  - ping the list for additional reviewers
>=20
> For now the prime intent of the tree is to feed it to James, although
> I'd welcome everyone interested to pull and test it.  If the scheme
> proves successful I'd love to invite more core scsi contributors to help
> with it and move to a shared kernel.org tree.

Is this a request for inclusion of those branches into linux-next
separately from the scsi tree itself?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/SA1utnxSaG3OjH0zuGrH_th
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTepvkAAoJEMDTa8Ir7ZwV3z4P/0lUm5v6aqqR5TFFAGZRXCuW
PKn/RKorDYW/Fq0uJDM9n2u1xjPG3l8RFEHzTSDQMr8o+/z6aM0mYbvEHyQ98fYu
qy0ov8qh+XsoCEBhyIUZC5IsyP+rOPGP7LCO2yX3Pf+fGhEFTYjgPH0ByUZGD11s
SPhniNh8M7j+0DU/AgzSfjfxhLiyWpVDcDckp4HJeZ45gsnI8dy6/87PUmQSOMtH
AqJDQ/AHjjy1qBqovLuHzn3atxfAXmteTBtb1MvsT5v6uomDV37AGBfXl2iLOcAF
FSXorAU2cnT/0rFdwKW7ydEON5i0k74hRd/59RpnNPj6Q7LZm9KF9LEWNT4d1Uxx
2s5Mwjpw5LdfcgRQRmHA+pfFZUOdk3LJlEI5O2aui2c5T6Vef6cgGFBBUhkHtCkq
O57DIg+/aE7X8ShDPDgE5HecZ5f6whtxVh9avl7DUlXRljsI1orMVJeS9lZqkTEW
m/TamKUOCULn8CKWrF+l0U71vRzcVUl6Hxenzm13krwIUNbcPp6LGNRtDeitwnvh
x55qs862kKnMfVjbqGNVs6hbdDVGlakOtBcEUNpnYN3wXB9LcB8ih7/sNl2KT5OD
YZo2sPJI1FudOfw8DxoZDmE29+S0+wMNOJ2o+zftBKme1XiTE9PWNJDJI1VvKD+R
kVB99lxnydNWpXhCTpQ/
=EcVt
-----END PGP SIGNATURE-----

--Sig_/SA1utnxSaG3OjH0zuGrH_th--

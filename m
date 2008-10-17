From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [BUG] linux-next: Tree for October 16 - softlockup detected at
 blk_invoke_request_fn
Date: Sat, 18 Oct 2008 00:15:33 +1100
Message-ID: <20081018001533.06ec0d1b.sfr@canb.auug.org.au>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au>
	<20081016204212.GC7534@linux.vnet.ibm.com>
	<20081017065558.GD19428@kernel.dk>
	<20081017102456.GA8115@linux.vnet.ibm.com>
	<20081017105753.GG19428@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__18_Oct_2008_00_15_33_+1100_rA+J70Sxcs+wtYxl"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081017105753.GG19428@kernel.dk>
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Sat__18_Oct_2008_00_15_33_+1100_rA+J70Sxcs+wtYxl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Fri, 17 Oct 2008 12:57:55 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> OK, I'm guessing it's a merge mess in linux-next. I tried to look at the
> diff, but it was pretty much impossible to read and even included lots
> of things in -git already.

If you are looking at the linux-next patch on kernel.org, then it is
relative to 2.6.27, so will contain a lot of stuff in Linus' tree.  Its
purpose is to allow people to recreate the linux-next tree from a kernel
tarball.

In the linux-next git tree, the point in Linus' tree that it is based on
the the "stable" branch.  If necessary, people should be able to bisect
between the "stabel" and "master" branches of a linux-next tree.  Or, I
am told, between one linux-next tree and another (but that sounds painful
to me).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__18_Oct_2008_00_15_33_+1100_rA+J70Sxcs+wtYxl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj4j/UACgkQjjKRsyhoI8zjEACfdkb2u8Qj4If0z7qWmpm4n9/q
f5IAoJHV9olNDzepaNvY8CrCSJrIk18I
=uN4x
-----END PGP SIGNATURE-----

--Signature=_Sat__18_Oct_2008_00_15_33_+1100_rA+J70Sxcs+wtYxl--

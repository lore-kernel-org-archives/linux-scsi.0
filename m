From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Tue, 12 May 2009 15:56:13 +1000
Message-ID: <20090512155613.881fa2ec.sfr@canb.auug.org.au>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
	<4A081002.4050802@in.ibm.com>
	<20090511115233.GB8112@parisc-linux.org>
	<4A081437.7000409@in.ibm.com>
	<20090511122135.GC8112@parisc-linux.org>
	<20090512045716.GC32535@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_May_2009_15_56_13_+1000_XEPp5_Ae/_uZPBoo"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090512045716.GC32535@wotan.suse.de>
Sender: linux-next-owner@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Sachin Sant <sachinp@in.ibm.com>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__12_May_2009_15_56_13_+1000_XEPp5_Ae/_uZPBoo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Tue, 12 May 2009 06:57:16 +0200 Nick Piggin <npiggin@suse.de> wrote:
>
> Hmm, I think (hope) your problems were fixed with the recent memory
> coruption bug fix for SLQB. (if not, let me know)
>=20
> This one possibly looks like a problem with remote memory allocation
> or memory hotplug or something like that. I'll do a bit of code
> review....

These are -next kernels which include the two fixes you posted recently
(I am pretty sure).  I am also getting the network failures that Sachin
is seeing on several of my machines here.  The previously reported
problems have gone away.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_May_2009_15_56_13_+1000_XEPp5_Ae/_uZPBoo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoJD30ACgkQjjKRsyhoI8yt4ACfUhS1N3pSKka6v0j6wNE1CLUy
ZJwAn2HHuo9jW7RDBnjcpJiDmu0pHtVD
=VeYZ
-----END PGP SIGNATURE-----

--Signature=_Tue__12_May_2009_15_56_13_+1000_XEPp5_Ae/_uZPBoo--

From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Nov 27 (scsi/aha1542)
Date: Wed, 28 Nov 2018 15:38:47 +1100
Message-ID: <20181128153847.08ead1c9@canb.auug.org.au>
References: <20181127152539.55426063@canb.auug.org.au>
        <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UQWXzwPW6x4LyBoYK=gMBs/"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

--Sig_/UQWXzwPW6x4LyBoYK=gMBs/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 27 Nov 2018 20:14:58 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> On 11/26/18 8:25 PM, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20181126:
> >  =20
>=20
> on i386:
>=20
> ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
>=20
> somewhere in aha1542_interrupt() according to objdump.

Presumably caused by commit

  1794ef2b150d ("scsi: aha1542: convert to DMA mapping API")

--=20
Cheers,
Stephen Rothwell

--Sig_/UQWXzwPW6x4LyBoYK=gMBs/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlv+G9cACgkQAVBC80lX
0GznJQgAhVR9Ayj/3/ionZLz8Fdbqjs0Hr2rG5KDRY9cHogF7ZusSUhjOGTMwzZD
0yc461rVUKyDosMl4sy9zuN0v87dAgTLMoIGRsiPaIQu/jsnqrrEKnALBsc5HDx/
RbsFqUd04+XWXQkXAUDNxOupxqSumb8e+EkAW/NZcXXVRqOA6cmrUo3Jgnd+IVNO
NOKUlQ5DJVKl2MKNOd6SUuh4cqPTUBl15gbhLR3wzXLok2D/HbQgUgJrPXC4h/Dp
WJxWfeK66+77ID9DUywQb5+hIgP5Hhg3JBxUAZpUHH0klEMKmO1gH2pN3xdfEA9P
8z6d+Xp6Gg9xlT5QzrxLq+tYRVRvAQ==
=2/vb
-----END PGP SIGNATURE-----

--Sig_/UQWXzwPW6x4LyBoYK=gMBs/--

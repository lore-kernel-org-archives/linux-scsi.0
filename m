From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: SCSI trees moved back to kernel.org
Date: Wed, 12 Oct 2011 09:26:18 +1100
Message-ID: <20111012092618.e35391f58873edb1cc0bb5cb@canb.auug.org.au>
References: <1316101053.2983.42.camel@dabdike.hansenpartnership.com>
	<1318351928.2992.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_09_26_18_+1100_11aiN1g+=zbuB7Yq"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1318351928.2992.19.camel@dabdike.int.hansenpartnership.com>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Wed__12_Oct_2011_09_26_18_+1100_11aiN1g+=zbuB7Yq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 11 Oct 2011 11:52:08 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> OK, all the trees are back in their usual locations on kernel.org,
> that's
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git

OK, I have switched to use those.  However the last one gives:

fatal: Couldn't find remote ref refs/heads/merge-base

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Oct_2011_09_26_18_+1100_11aiN1g+=zbuB7Yq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlMKKAAoJEECxmPOUX5FE2gAQAJjIjHoCoTrTYPwLuraaejBB
ZhcK74q4UqtiDrfrc9m7eXumbf7wLya+6jzqZB6X6c5i30xCLV52SXF/GUBkKpl4
UgHEUeG8u6tjGLnsFPCE6cytPfD4dcoU57I+X9LVtlAuMn5xKXlj1g7NNkKjKGjO
09JWlrTT8gY1wBLrjhksJY0bnywwdq9E7/IZA0p/h2rdH7M84QHFSHxCMKgPXJZg
qEIp4xBV0x3fT+z4cE5bXoy2RGO0BzXpz9IqQsNTZ+NUSor39xkDYbfiwh/rG4tL
db22es4DhfwU1Q7zA36b6T93BBH89OmNktln7Vn/+9xo0+UtQ2zkbKyfVmEFATBh
Lf9UpF7471x9sptQJYbUXHFxCMEnyAQjkKGQuAvxREJhI1eQY5BXPsRl8z41Bh+z
zkb2596KylDAdoSEbxwPLg4xqrKKolWmMVub4XLPDd/z6bMBV2y5w5kN/QnqG4cW
Cj08RN7KkZ4ZkNuxPidwvrBZ5IY7BMRBN8UfLU9Xj/q+vPkMVa8oonhioEh5/R6P
4ZX9wcaOrTekjxYrXUfRT4cX4dG/b4TrE2v8yMeJpeq6XbXOdzA/UVKpUTYGBk93
ab1sJox7j1ICbR2y3I0aNaEgvGXH9pvwxRQnKAPNzMWB31mxBRvs7sw9MsrSDrSU
sBYLioR9927w3ckzluN6
=pOc1
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_09_26_18_+1100_11aiN1g+=zbuB7Yq--

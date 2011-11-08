From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Tue, 8 Nov 2011 11:03:00 +1100
Message-ID: <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Nov_2011_11_03_00_+1100_UefxJahxFOuZmL9e"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__8_Nov_2011_11_03_00_+1100_UefxJahxFOuZmL9e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Actually, I don't think it's anything to do with this: it's Anton's
> fault
>=20
> commit f7c9c6bb14f3104608a3a83cadea10a6943d2804
> Author: Anton Blanchard <anton@samba.org>
> Date:   Thu Nov 3 08:56:22 2011 +1100
>=20
>     [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sdev
>=20
> Doesn't completely do the teardown.  The true fix is to do a proper
> teardown instead of hand rolling it.  Does this fix it for you?

I don't get the WARNING any more, but now get lots of:

scsi: killing requests for dead queue

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Nov_2011_11_03_00_+1100_UefxJahxFOuZmL9e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuHG0AAoJEECxmPOUX5FEAzoP/i/XaBxyy7qTQxgiKOw18vj3
t91awLvHiYMr85j/7A18Z2B6wS7wkRYKRT7vFuTy2i9lCgwNXE9gZd38jH0PZgzM
gjc7wtK/voRGFmas+KupzLlBSf642kO9wOC/+U6sYpE2t4FpK/l1fIzI3YxXSMtO
ZCz+8w8h1bAFRPB2WZW6BPd4jBiYpTYK3ha6k0izQOqnNm84A5i0Wjeo1VIyo9ho
VjPuuZYMnR8CGFJfzztA0Ba8vP2M3cE/Eu0hyuS+DZ2bWxvO5FyshWITQan6NlKg
7D7zzun8POeMT6ba7ac83MlbJLhAByqVzmQBN2HRRYsCucCD6lEZp5DrTBBX50Ok
yhLXryImVjiYCjmyL2JMy5W9jpjbFG4TGfK6en/2OWIwAc70UOm2uXstsaMets2G
5iODijOLn4lWS129WgCw80UC0xD1aoGVaBW367SyzZuQ8+TW9rKTYBZo0gxbqBaU
Od8CkKkNo4BalylbbXeI4lAUZIjswXPUVb0+Gh05LdDNPic0ksjdrIltcf4AWCfK
bon2LNQq6/U5JF3IpHafZQCp/BZG5lWMT3VMLKzZv3kKQUtQabeBOnrCSmnvYHdf
5XxpwVqq3+G7OyhY2/xtcQ0jxzbfUzrwgvnxOlp1SdtEYXYY9GAz74wzQcyUQfGf
nokrAfNdahbXaANWzOkF
=4nW7
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Nov_2011_11_03_00_+1100_UefxJahxFOuZmL9e--

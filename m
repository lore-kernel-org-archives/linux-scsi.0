From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Backport of a fix for a race condition in HPSA driver (3rd time
 is the charm)
Date: Fri, 12 Dec 2014 05:16:44 +0000
Message-ID: <1418361404.3599.81.camel@decadent.org.uk>
References: <CANcb+4vTzLBGkkvrBo-dsCERFvX-J=D-4Sgx6Vz_-e1jJpokYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ljmNzOdKv0AIi4KciJsA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51513 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114AbaLLFRB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2014 00:17:01 -0500
In-Reply-To: <CANcb+4vTzLBGkkvrBo-dsCERFvX-J=D-4Sgx6Vz_-e1jJpokYQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Masoud Sharbiani <msharbiani@twopensource.com>
Cc: stable@vger.kernel.org, thenzl@redhat.com, scameron@beardog.cce.hp.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org


--=-ljmNzOdKv0AIi4KciJsA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-11-14 at 11:26 -0800, Masoud Sharbiani wrote:
> Dear stable maintainers,
> Can you please backport commitid
> 2cc5bfaf854463d9d1aa52091f60110fbf102a9 ([SCSI] hpsa: fix a race in
> cmd_free/scsi_done) to 3.10 stable (and earlier, if applicable)? It
> seems to fix an issue that we have run into a couple of times.
>=20
> Many thanks,
> Masoud Sharbiani <msharbiani@twitter.com> <msharbiani@twopensource.com>
>=20
> PS: Apologies for duplicate message that may have been captured in
> your spam folder.

I've queued this up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-ljmNzOdKv0AIi4KciJsA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIp6POe/yOyVhhEJAQpgJRAAgZjItJmFoNWAQPhBK9WRF/VnurR/JlWY
qqP2sj/+RLTilDedQTNseNDCuLQVRa1AaY5k+8BNLK13PdyLdgXAOSZNQDG7u67G
WBXGhsdO55CrjMCUiaUWH3P4T53PdCjXepYI/AjAJyyD+zEe75glKxbDGwRpYZpx
1/+NN/2g5Ma/1w+KT3qD+wM/EP3vfTDqvHcPcYGmsRjXM6+RvN/LoDPZl7za+7FQ
BEAdumZpGK3MAynQWrdtzF1/vLyBMgp9ll0kG1w5CZxjv2IfUmUfQ/wGlmNYGuvH
UWLzDS79iA6UD9bGxkXOvhpm8YWpQksD3gVPnnqBdZA2yX+AfLW/fKrfNbPJm+9q
KVfu0gdhfSLpYKrSZlvJqBMtjEFMf1w2bbL9u6OUu2oAHqh2Lc3MO5qzfJEI4TK5
bIcFyh4rbJU4nfjt5PR4/QGdWB36H2q1Gem7f6cvDH6/afH9qSgb4bD/r9wFfzRM
9hlWyvu2S2pGiIh8N1PFa7p5mRDyiZgwbbSKwHSYZn9DyMbmUiyTJv+b/3lX2s27
IM9Y1GWOH3m7IKwPEuMNqVQ+HMPJf9V2ZnhNChB7u181Jy02Dj85os8P0ggHkj1l
tob6iVRQ8tdywcdXkvdkOLh73VHTfZYsi0EdC0nYmhcy4J0QWAzkKojB+lZWzlfP
tRm2cwr8Ww8=
=dDhc
-----END PGP SIGNATURE-----

--=-ljmNzOdKv0AIi4KciJsA--

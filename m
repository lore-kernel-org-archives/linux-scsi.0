From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Update to SCSI trees for Linux Next
Date: Mon, 23 Apr 2012 21:11:46 +1000
Message-ID: <20120423211146.b18b4648494217f7150c3145@canb.auug.org.au>
References: <1335177821.4191.17.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_21_11_46_+1000__raGaOll+00F0ssg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:55534 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2DWLL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 07:11:58 -0400
In-Reply-To: <1335177821.4191.17.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

--Signature=_Mon__23_Apr_2012_21_11_46_+1000__raGaOll+00F0ssg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 23 Apr 2012 11:43:41 +0100 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Just to let you know that SCSI is moving on to a single tree model from
> now on.  The new tree is
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>=20
> And the branch for next is for-next.
>=20
> Could you drop both the scsi-misc-2.6 and scsi-rc-fixes-2.6 tree, please
> because I'll send everything through this for-next branch.

Done.

> For the time being, could you keep the scsi-post-merge-2.6 tree?  It's
> easier when resolving conflicts amongst other trees to use a separate
> git tree (although we haven't actually had to use this one for a while).

No problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Apr_2012_21_11_46_+1000__raGaOll+00F0ssg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlTjyAAoJEECxmPOUX5FEyi8P/izk84Lu3ATSSWRqjvE0mPIJ
lSL6nA1WSgQe33T53KT3SFavI4VtpzLfYs/slLMzr2Yf4uhH16pIAgYM/nj0PTvU
u1I5fG+UxmxvhU5DP4dmYo371coOL+4M5mWlR3eBNnA/XsQSlgaT3CPZVzegtN9a
ud8M2LaTFI1rXb9ZUCMc5i/5EZYjD/KLvyiMshq4cDMdP13b1IZ6ul5mYd12Nxyk
WKiq2s6gP20A5hfA57biN2SEg7M2mFAF2XwtqgYBPD9zND7q4aAgqPqSpVUOxA1j
nd7RWoijoktammo+LwT0TMgJIOM9tto8Q/rc1IfqZfab2oLRk79pKvXR71xYy3zs
y7b/vsyGSESrCezEw0aGU2rvUSMImtNfc5vcO1kFk3OT5B/wbPpYeYFf1XzeU2pX
ERiHAIW517I2EezTXMTK5SUwgJt9jrZi08se4ssZh7bss5wEPTF7DwEd0VZZFZH7
T7TecGMCME325X2u5gMLLxLo73kULjHeaxXwqwKvI/hdRh4g5MhdJpGAUjq55o9y
rrHjWMn1PwajdLF8uQmpbH/u/zrndPE4h6A81rUPOhjG6mzh0XhZBpCgxKT200bM
ME045ZXRi9AuRr7ycKazT6KCg+FBi5T6fqz7tnQsDZkdrXjYSDPwNhfYgBY7aAl7
IXeM6dy6aFjDf9bvjCau
=R8Q/
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_21_11_46_+1000__raGaOll+00F0ssg--

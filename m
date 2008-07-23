From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/1] 3ware add MSI support
Date: Wed, 23 Jul 2008 07:29:42 +0200
Message-ID: <200807230729.48728.eike-kernel@sf-tec.de>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart34768945.b1oiGRKDI0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:40658 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYGWFgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2008 01:36:31 -0400
In-Reply-To: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart34768945.b1oiGRKDI0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch, 23. Juli 2008 schrieb adam radford:
> This patch for the 3w-9xxx scsi driver applies on top of the
> BKL-pushdown changes in -git9.
>
> This patch does the following:
>
> - Increase max AENs drained to 256.
> - Add MSI support and "use_msi" module parameter.
> - Fix bug in twa_get_param() on 4GB+.
> - Use pci_resource_len() for ioremap().

Why not simply use pci_iomap()? Also I bet someone will step up and request=
=20
this should be split into one patch for each change. #1 and #3 can get a=20
little more description at the same time.

Greetings,

Eike

--nextPart34768945.b1oiGRKDI0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIhsHMXKSJPmm5/E4RAgRpAKCiCercDfp03w3V5OoIF8BV56aRNgCgj4Lw
lWLgNQbYDVX96dDQ+4mLpAE=
=zCqk
-----END PGP SIGNATURE-----

--nextPart34768945.b1oiGRKDI0--

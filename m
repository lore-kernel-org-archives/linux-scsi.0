From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Mon, 26 Jul 2010 17:46:22 +0200
Message-ID: <201007261746.29454.eike-kernel@sf-tec.de>
References: <201007260807.45533.eike-kernel@sf-tec.de> <FD2BDBE06AC58549AE9E16C08B45675D03B14F61@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart51209041.1ETlfGFXY7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51160 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab0GZPq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 11:46:29 -0400
In-Reply-To: <FD2BDBE06AC58549AE9E16C08B45675D03B14F61@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <Achim_Leubner@pmc-sierra.com>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>

--nextPart51209041.1ETlfGFXY7
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Achim Leubner wrote:
> Hi Rolf,
>=20
> The patch looks good for me so from my side we can include it. Sorry for
> the delay - I will try to give quick answers for future requests. Please
> pay attention that my personal email address has changed because we are
> now part of PMC-Sierra Inc. But aacraid@adaptec.com remains active.

Can I get an Acked-by of any of you so James can push this for the next mer=
ge=20
window?

Also please have a look at the patch at

http://marc.info/?l=3Dlinux-scsi&m=3D127472836901937&w=3D2

and give that an Acked-by, too.

Eike

--nextPart51209041.1ETlfGFXY7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkxNrdUACgkQXKSJPmm5/E5xxgCfd6G+SXXkkekjX1jSwaUq8RsP
ZPYAoKgFf3Z6g0dY+XmZT+xKQOsA67Zt
=XUUb
-----END PGP SIGNATURE-----

--nextPart51209041.1ETlfGFXY7--

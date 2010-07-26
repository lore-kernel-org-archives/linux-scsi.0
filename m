From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Mon, 26 Jul 2010 18:53:00 +0200
Message-ID: <201007261853.08107.eike-kernel@sf-tec.de>
References: <201007260807.45533.eike-kernel@sf-tec.de> <201007261746.29454.eike-kernel@sf-tec.de> <1280160466.7125.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2305125.dhWbeJ8PUx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:40742 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab0GZQxQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 12:53:16 -0400
In-Reply-To: <1280160466.7125.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Achim Leubner <Achim_Leubner@pmc-sierra.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>

--nextPart2305125.dhWbeJ8PUx
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

James Bottomley wrote:
> On Mon, 2010-07-26 at 17:46 +0200, Rolf Eike Beer wrote:
> > Achim Leubner wrote:
> > > Hi Rolf,
> > >=20
> > > The patch looks good for me so from my side we can include it. Sorry
> > > for the delay - I will try to give quick answers for future requests.
> > > Please pay attention that my personal email address has changed
> > > because we are now part of PMC-Sierra Inc. But aacraid@adaptec.com
> > > remains active.
> >=20
> > Can I get an Acked-by of any of you so James can push this for the next
> > merge window?
>=20
> Actually, this is sufficient for me to translate into an acked-by

Whatever works ;)

Eike

--nextPart2305125.dhWbeJ8PUx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkxNvXMACgkQXKSJPmm5/E5xAACgh80mordH5ZipsLNgLn8Og3YB
QVcAnAodk2vAZn2JO1XEwMjELMDlAUkc
=FI2z
-----END PGP SIGNATURE-----

--nextPart2305125.dhWbeJ8PUx--

From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: target: Fix excessive stack usage
Date: Fri, 7 Jan 2011 17:32:22 +0100
Message-ID: <201101071732.27612.eike-kernel@sf-tec.de>
References: <1294187361.7879.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2407596.Z0znFfCdnp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:59854 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1AGQef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 11:34:35 -0500
In-Reply-To: <1294187361.7879.21.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart2407596.Z0znFfCdnp
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

James Bottomley wrote:

> @@ -1870,6 +1870,10 @@ static int __core_scsi3_update_aptpl_buf(
>  				"No Registrations or Reservations\n");
>  		return 0;
>  	}
> +	tmp =3D kmalloc(1024, GFP_KERNEL);
> +	if (!tmp)
> +		return -1;

Shouldn't this return useful errorcodes all over the place instead of just =
=2D1?=20
Like -ENOMEM?

Eike

--nextPart2407596.Z0znFfCdnp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0nQBsACgkQXKSJPmm5/E6KPQCeJdvhdhyUvwLHD50DHjG6Pz3D
rLQAnipfmENbmutmHTpnDB2cnbga1Ap3
=w46Q
-----END PGP SIGNATURE-----

--nextPart2407596.Z0znFfCdnp--

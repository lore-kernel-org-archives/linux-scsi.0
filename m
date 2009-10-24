From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] Updated: Add new driver for LSI 3ware 9750
Date: Sat, 24 Oct 2009 11:39:18 +0200
Message-ID: <200910241139.26587.eike-kernel@sf-tec.de>
References: <b1bc6a000910231452x27581ef0qeeea8f1bb30cbd8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2786870.OsFDrGO0tT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47386 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZJXJjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2009 05:39:32 -0400
In-Reply-To: <b1bc6a000910231452x27581ef0qeeea8f1bb30cbd8f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

--nextPart2786870.OsFDrGO0tT
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

adam radford wrote:

> +static struct device_attribute twl_host_stats_attr =3D {
> +	.attr =3D {
> +		.name =3D 	"3ware_stats",
> +		.mode =3D		S_IRUGO,
> +	},
> +	.show =3D twl_show_stats
> +};

There is a minor whitespace issue here: name is followed by =3D<space><tab>=
=20
while its =3D<tab><tab> in the mode line. Nothing worth a new patch by itse=
lf.

Eike

--nextPart2786870.OsFDrGO0tT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkriy04ACgkQXKSJPmm5/E6obQCgivBxQJdrxj6i9U8edT9tWCHI
Vc0An2XR9c0WeFW5x31VsdUwNQWb4vfR
=bzfp
-----END PGP SIGNATURE-----

--nextPart2786870.OsFDrGO0tT--

From: Tony Vroon <chainsaw@gentoo.org>
Subject: Re: aic7xxx regression occuring after 2.6.12 final
Date: Sat, 02 Jul 2005 17:46:28 +0100
Message-ID: <1120322788.22046.2.camel@localhost>
References: <1120085446.9743.11.camel@localhost>
	 <1120318925.21935.9.camel@localhost>  <1120321322.5073.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+gXiVETEcM9B9TC//Mvg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.irishbroadband.ie ([62.231.32.13]:54744 "EHLO
	smtp2.irishbroadband.ie") by vger.kernel.org with ESMTP
	id S261191AbVGBQrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2005 12:47:22 -0400
In-Reply-To: <1120321322.5073.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>


--=-+gXiVETEcM9B9TC//Mvg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2005-07-02 at 12:22 -0400, James Bottomley wrote:
> Well, my best guess is that this is a double bug.  I think the
> aic7xxx_core is processing the reject wrongly and the device is
> rejecting a QAS or IU negotiation attempt.
>=20
> So, see if the attached patch helps.

Unfortunately I see no visible changes in the output; the system hangs
at the same point.
What does that asynchronous line mean? I  see that on all kernels that
do not boot properly. 2.6.12; 2.6.12.1 and 2.6.12.2 do not display it,
and boot just fine.

target0:0:0: asynchronous

It appears even before vendor & model information is displayed for the
Fujitsu drive.

> James

Tony.


--=-+gXiVETEcM9B9TC//Mvg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1-ecc0.1.6 (GNU/Linux)

iD8DBQBCxsTkp5vW4rUFj5oRAr/YAJ9tPuwTwJJ7nWywS5cPxoMtkfWpmQCfRbYV
3+VGphrHLIjhjPqzl9owsIs=
=RMKJ
-----END PGP SIGNATURE-----

--=-+gXiVETEcM9B9TC//Mvg--


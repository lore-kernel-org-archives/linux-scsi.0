From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Mon, 18 Jan 2010 15:48:50 +0100
Message-ID: <201001181549.13534.eike-kernel@sf-tec.de>
References: <87r5pta66n.fsf@gmail.com> <1263754052.2802.2.camel@mulgrave.site> <87k4vglet8.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10828444.1dEv8PZR09";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:53330 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab0AROtU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2010 09:49:20 -0500
In-Reply-To: <87k4vglet8.fsf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Kadianakis <desnacked@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, james.smart@emulex.com

--nextPart10828444.1dEv8PZR09
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

George Kadianakis wrote:
> From: George Kadianakis <desnacked {bomb} gmail {point} com>
>=20
> A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx
> interrupts. This patch restores lpfc's ability to support MSI-X/MSI
> interrupts that the "Addition of SLI4 Interface - Base Support" patch [2]
> broke.
> It reestablishes MSI-X as the default interrupt method and in case MSI-X =
is
> not supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.
>=20
> [1]: http://bugs.gentoo.org/show_bug.cgi?id=3D296319
> [2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d
>=20
> Signed-off-by:  George Kadianakis <desnacked@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index e1a30a1..936ecaf 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
>  /*
>  # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
>  #		support this feature
> -#       0  =3D MSI disabled (default)
> +#       0  =3D MSI disabled
>  #       1  =3D MSI enabled
> -#       2  =3D MSI-X enabled
> +#       2  =3D MSI-X enabled (default)
>  # Value range is [0,2]. Default value is 0.
                                            ^

This is still wrong.

>  */
> -LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
> +LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
>  	    "MSI-X (2), if possible");
>=20
>  /*

Eike

--nextPart10828444.1dEv8PZR09
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktUdNoACgkQXKSJPmm5/E5O7ACgjzeK4pnJAUesi7cJipPnpaaF
d7kAn3C19yXz5EUuwpbEKOHWtL8oqxZV
=TwvY
-----END PGP SIGNATURE-----

--nextPart10828444.1dEv8PZR09--

From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Sun, 18 Dec 2011 15:43:34 +0100
Message-ID: <4EEDFC16.90303@nod.at>
References: <1321572864-23628-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE41059AB5314126B7C474680"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:55710 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1LROng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2011 09:43:36 -0500
In-Reply-To: <1321572864-23628-1-git-send-email-richard@nod.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE41059AB5314126B7C474680
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 18.11.2011 00:34, schrieb Richard Weinberger:
> scsi_dh_attach() should return a negative value on error.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/scsi/scsi_dh.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index e3f2db2..e07ab10 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *n=
ame)
>  }
>  static inline int scsi_dh_attach(struct request_queue *req, const char=
 *name)
>  {
> -	return SCSI_DH_NOSYS;
> +	return -SCSI_DH_NOSYS;
>  }
>  static inline void scsi_dh_detach(struct request_queue *q)
>  {

James,

can you please pickup this patch?

Thanks,
//richard


--------------enigE41059AB5314126B7C474680
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJO7fwWAAoJEN9758yqZn9e9F8H/1/E9DIM+oP8rJcMAUt1L0w7
lhXebzYude0Q2KOzff34WtFg4czWOfEL/qwguooIreGtxUawrxjUWbTqTghQwDkm
Z6tfYLXqxje1xyOiwv4oUptHjakwUJNIl3pSJrLl7eMN07rPQ0xs/ENV/senstrk
R/BEQRfEBkw9fma73ZH5XEQCVKTFqohua4hNcmEyj9NPLn/4lBeH+xfx7+Ldl2Z0
Flc2x4PPOnVcjs54FM2oUCGozMprzdq6D9HabNiHERvrUV5ainxm1oRGUwhqR1Y/
ZTxIbgzg9bAKqmq3TYQC/qIguk911wBhnFrEjcDuS9crKcg4klILfNIFINHFHVQ=
=sNk5
-----END PGP SIGNATURE-----

--------------enigE41059AB5314126B7C474680--

From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 05/17] be2iscsi:Fix typo function name mismatch
Date: Wed, 21 Mar 2012 23:21:11 +0100
Message-ID: <5978796.vmDf5npbmM@eto>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu> <1332294488-13684-6-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5464576.XJfzxjozH1"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47095 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964796Ab2CUWVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Mar 2012 18:21:50 -0400
In-Reply-To: <1332294488-13684-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>


--nextPart5464576.XJfzxjozH1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Dienstag 20 M=E4rz 2012, 20:47:56 schrieb michaelc@cs.wisc.edu:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>=20
> Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c
> b/drivers/scsi/be2iscsi/be_iscsi.c index 33c8f09..2bb681e 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -221,7 +221,7 @@ int beiscsi_ep_get_param(struct iscsi_endpoint *e=
p,
>  =09struct beiscsi_endpoint *beiscsi_ep =3D ep->dd_data;
>  =09int len =3D 0;
>=20
> -=09SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param=3D %d\n", p=
aram);
> +=09SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_get_param, param=3D %d\n", par=
am);
>=20
>  =09switch (param) {
>  =09case ISCSI_PARAM_CONN_PORT:

What about:

SE_DEBUG(DBG_LVL_8, "In %s, param=3D %d\n", __func__, param);

Eike
--nextPart5464576.XJfzxjozH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9qVF0ACgkQXKSJPmm5/E5wbQCdFQT6mpCtyOFQk30fY/AkpjDb
JPAAn01jh8XxizyztMaQc5TViRxEam5Q
=ArMJ
-----END PGP SIGNATURE-----

--nextPart5464576.XJfzxjozH1--


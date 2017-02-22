From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 3/3] cciss: Remove kmalloc cast
Date: Wed, 22 Feb 2017 15:16:31 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F32249D@avsrvexchmbx1.microsemi.net>
References: <1487743958-4208-1-git-send-email-me@tobin.cc>
 <1487743958-4208-4-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0065.outbound.protection.outlook.com ([104.47.42.65]:42336
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932925AbdBVPQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 10:16:57 -0500
In-Reply-To: <1487743958-4208-4-git-send-email-me@tobin.cc>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tobin C. Harding
> Sent: Wednesday, February 22, 2017 12:13 AM
> To: Don Brace <don.brace@microsemi.com>
> Cc: linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org; Tobin C.
> Harding <me@tobin.cc>
> Subject: [PATCH 3/3] cciss: Remove kmalloc cast
>=20
> EXTERNAL EMAIL
>=20
>=20
> Coccinelle emits a warning about casting the return value of
> kmalloc(). Coccinelle suggests removing the cast as do
> kerneljanitors.
>=20
> Remove cast from kmalloc() call.
>=20
> Signed-off-by: Tobin C. Harding <me@tobin.cc>

Acked-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/block/cciss_scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index f5c21f3..01a1f7e 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -647,8 +647,7 @@ cciss_scsi_setup(ctlr_info_t *h)
>         struct cciss_scsi_adapter_data_t * shba;
>=20
>         ccissscsi[h->ctlr].ndevices =3D 0;
> -       shba =3D (struct cciss_scsi_adapter_data_t *)
> -               kmalloc(sizeof(*shba), GFP_KERNEL);
> +       shba =3D kmalloc(sizeof(*shba), GFP_KERNEL);
>         if (shba =3D=3D NULL)
>                 return;
>         shba->scsi_host =3D NULL;
> --
> 2.7.4

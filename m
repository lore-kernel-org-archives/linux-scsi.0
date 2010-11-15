From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 25/44] drivers/scsi/pm8001: Remove unnecessary semicolons
Date: Mon, 15 Nov 2010 11:27:32 +0800
Message-ID: <1671200DA80140558ED0D17FB55585AD@usish.com.cn>
References: <cover.1289789604.git.joe@perches.com> <20b352f91642ca45ad730d8eeec0bbd323d26626.1289789605.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:58240 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0KOD14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Nov 2010 22:27:56 -0500
In-Reply-To: <20b352f91642ca45ad730d8eeec0bbd323d26626.1289789605.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Joe Perches' <joe@perches.com>, 'Jiri Kosina' <trivial@kernel.org>
Cc: lindar_liu@usish.com, "'James E.J. Bottomley'" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_init.c
> b/drivers/scsi/pm8001/pm8001_init.c
> index f8c86b2..be210dd 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -160,7 +160,7 @@ static void pm8001_free(struct pm8001_hba_info
*pm8001_ha)
>  static void pm8001_tasklet(unsigned long opaque)
>  {
>  	struct pm8001_hba_info *pm8001_ha;
> -	pm8001_ha =3D (struct pm8001_hba_info *)opaque;;
> +	pm8001_ha =3D (struct pm8001_hba_info *)opaque;
>  	if (unlikely(!pm8001_ha))
>  		BUG_ON(1);
>  	PM8001_CHIP_DISP->isr(pm8001_ha);
> --
> 1.7.3.1.g432b3.dirty
[Jack Wang] Acked-by: Jack Wang <jack_wang@usish.com>
Thanks=A3=A1


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

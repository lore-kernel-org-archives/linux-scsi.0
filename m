From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/14] lpfc: Remove unnessary cast
Date: Mon, 14 Sep 2015 09:34:32 +0200
Message-ID: <55F67888.90208@suse.de>
References: <55e4bd89.wnXoOtgVrknAjUqh%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbbINHee (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:34:34 -0400
In-Reply-To: <55e4bd89.wnXoOtgVrknAjUqh%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> From: Firo Yang <firogm@gmail.com>
>=20
> kzalloc() returns a void pointer - no need to cast it in
> drivers/scsi/lpfc/lpfc_init.c::lpfc_sli_driver_resource_setup()
>=20
> Signed-off-by: Firo Yang <firogm@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index 1992e74..da9b6fc 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4982,8 +4982,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba =
*phba)
>  	}
> =20
>  	if (!phba->sli.ring)
> -		phba->sli.ring =3D (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring =3D kzalloc(LPFC_SLI3_MAX_RING *
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
>  	if (!phba->sli.ring)
>  		return -ENOMEM;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

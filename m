From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/14] lpfc: fix model description
Date: Mon, 14 Sep 2015 09:34:11 +0200
Message-ID: <55F67873.2090300@suse.de>
References: <55e4bd88.eMQzUsAqXxOF6Qi2%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbbINHeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:34:13 -0400
In-Reply-To: <55e4bd88.eMQzUsAqXxOF6Qi2%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> From: Sebastian Herbszt <herbszt@gmx.de>
>=20
> Remove trailing space from model description.
>=20
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index f962118..1992e74 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, =
uint8_t *mdp, uint8_t *descp)
>  				phba->Port);
>  		else if (max_speed =3D=3D 0)
>  			snprintf(descp, 255,
> -				"Emulex %s %s %s ",
> +				"Emulex %s %s %s",
>  				m.name, m.bus, m.function);
>  		else
>  			snprintf(descp, 255,
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

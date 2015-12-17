From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/17] lpfc: Fix RDP Speed reporting.
Date: Thu, 17 Dec 2015 09:25:15 +0100
Message-ID: <5672716B.70203@suse.de>
References: <5671efbf.h8YAdmlPeIEJ3AcO%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbbLQIZR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 03:25:17 -0500
In-Reply-To: <5671efbf.h8YAdmlPeIEJ3AcO%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 12/17/2015 12:11 AM, James Smart wrote:
>
> Fix RDP Speed reporting.
>
> Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_el=
s.c
> index 3394648..f7a2967 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -4730,28 +4730,25 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_d=
esc *desc, struct lpfc_hba *phba)
>
>   	desc->tag =3D cpu_to_be32(RDP_PORT_SPEED_DESC_TAG);
>
> -	switch (phba->sli4_hba.link_state.speed) {
> -	case LPFC_FC_LA_SPEED_1G:
> +	switch (phba->fc_linkspeed) {
> +	case LPFC_LINK_SPEED_1GHZ:
>   		rdp_speed =3D RDP_PS_1GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_2G:
> +	case LPFC_LINK_SPEED_2GHZ:
>   		rdp_speed =3D RDP_PS_2GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_4G:
> +	case LPFC_LINK_SPEED_4GHZ:
>   		rdp_speed =3D RDP_PS_4GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_8G:
> +	case LPFC_LINK_SPEED_8GHZ:
>   		rdp_speed =3D RDP_PS_8GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_10G:
> +	case LPFC_LINK_SPEED_10GHZ:
>   		rdp_speed =3D RDP_PS_10GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_16G:
> +	case LPFC_LINK_SPEED_16GHZ:
>   		rdp_speed =3D RDP_PS_16GB;
>   		break;
> -	case LPFC_FC_LA_SPEED_32G:
> -		rdp_speed =3D RDP_PS_32GB;
> -		break;
>   	default:
>   		rdp_speed =3D RDP_PS_UNKNOWN;
>   		break;
>
What happened to 32G? Has development ceased on that?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/21] lpfc: Add sysfs proc_name support
Date: Fri, 15 Jul 2016 15:09:59 +0200
Message-ID: <ab754063-db9f-0a85-5a86-3f98d9abacc9@suse.de>
References: <577d5d9f.+1zwDMnCrvR4Oepn%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcGONKF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:10:05 -0400
In-Reply-To: <577d5d9f.+1zwDMnCrvR4Oepn%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 07/06/2016 09:35 PM, James Smart wrote:
>=20
> Add sysfs proc_name support
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index 3bd0be6..12b8e82 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5886,6 +5886,7 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, str=
uct lpfc_name *vport_wwpn,
>  struct scsi_host_template lpfc_template_s3 =3D {
>  	.module			=3D THIS_MODULE,
>  	.name			=3D LPFC_DRIVER_NAME,
> +	.proc_name		=3D LPFC_DRIVER_NAME,
>  	.info			=3D lpfc_info,
>  	.queuecommand		=3D lpfc_queuecommand,
>  	.eh_abort_handler	=3D lpfc_abort_handler,
> @@ -5910,6 +5911,7 @@ struct scsi_host_template lpfc_template_s3 =3D =
{
>  struct scsi_host_template lpfc_template =3D {
>  	.module			=3D THIS_MODULE,
>  	.name			=3D LPFC_DRIVER_NAME,
> +	.proc_name		=3D LPFC_DRIVER_NAME,
>  	.info			=3D lpfc_info,
>  	.queuecommand		=3D lpfc_queuecommand,
>  	.eh_abort_handler	=3D lpfc_abort_handler,
> @@ -5935,6 +5937,7 @@ struct scsi_host_template lpfc_template =3D {
>  struct scsi_host_template lpfc_vport_template =3D {
>  	.module			=3D THIS_MODULE,
>  	.name			=3D LPFC_DRIVER_NAME,
> +	.proc_name		=3D LPFC_DRIVER_NAME,
>  	.info			=3D lpfc_info,
>  	.queuecommand		=3D lpfc_queuecommand,
>  	.eh_abort_handler	=3D lpfc_abort_handler,
>=20
Hehe. Finally.
We have been carrying a similar for ages in SLES :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/21] lpfc: Correct RDP response Revision location
Date: Fri, 15 Jul 2016 15:17:41 +0200
Message-ID: <3714eddd-8dd3-d9d4-4940-342bfddb8547@suse.de>
References: <577d5da4.qF0SkwMSM91wH60d%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbcGONRn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:17:43 -0400
In-Reply-To: <577d5da4.qF0SkwMSM91wH60d%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Correct RDP response Revision location
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_hw.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.=
h
> index c99c2b3..8226543 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -1239,8 +1239,8 @@ struct fc_rdp_opd_sfp_info {
>  	uint8_t            vendor_name[16];
>  	uint8_t            model_number[16];
>  	uint8_t            serial_number[16];
> -	uint8_t            reserved[2];
>  	uint8_t            revision[2];
> +	uint8_t            reserved[2];
>  	uint8_t            date[8];
>  };
> =20
>=20
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

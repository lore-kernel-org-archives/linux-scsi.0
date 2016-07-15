From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/19] qla2xxx: Fix BBCR offset
Date: Fri, 15 Jul 2016 15:03:12 +0200
Message-ID: <6b13af67-9082-2ecd-5714-381f95cfab07@suse.de>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
 <1467818075-15246-19-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbcGONDO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:03:14 -0400
In-Reply-To: <1467818075-15246-19-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 07/06/2016 05:14 PM, Himanshu Madhani wrote:
> From: Sawan Chandak <sawan.chandak@qlogic.com>
>=20
> Fixes: 969a619 ("qla2xxx: Add support for buffer to buffer credit val=
ue for ISP27XX.")
> Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_fw.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla=
_fw.h
> index 4c0f3a7..8a2368b 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1288,7 +1288,7 @@ struct vp_rpt_id_entry_24xx {
> =20
>  	uint8_t vp_idx_map[16];
> =20
> -	uint8_t reserved_4[28];
> +	uint8_t reserved_4[24];
>  	uint16_t bbcr;
>  	uint8_t reserved_5[6];
>  };
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

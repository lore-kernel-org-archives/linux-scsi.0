From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/11] qla2xxx: Update driver version to 8.07.00.33-k
Date: Wed, 27 Jan 2016 09:48:33 +0100
Message-ID: <56A88461.6040906@suse.de>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453828246-28686-12-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbcA0Isf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 03:48:35 -0500
In-Reply-To: <1453828246-28686-12-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 01/26/2016 06:10 PM, Himanshu Madhani wrote:
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_version.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xx=
x/qla_version.h
> index 6d31faa..0bc93fa 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -7,7 +7,7 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "8.07.00.26-k"
> +#define QLA2XXX_VERSION      "8.07.00.33-k"
> =20
>  #define QLA_DRIVER_MAJOR_VER	8
>  #define QLA_DRIVER_MINOR_VER	7
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

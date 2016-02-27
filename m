From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/6] hisi_sas: update driver version to 1.3
Date: Sat, 27 Feb 2016 20:00:15 +0800
Message-ID: <56D18FCF.60400@suse.de>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
 <1456393335-38294-7-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456393335-38294-7-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/25/2016 05:42 PM, John Garry wrote:
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas=
/hisi_sas.h
> index c92e65b..29e89f3 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -23,7 +23,7 @@
>  #include <scsi/sas_ata.h>
>  #include <scsi/libsas.h>
> =20
> -#define DRV_VERSION "v1.2"
> +#define DRV_VERSION "v1.3"
> =20
>  #define HISI_SAS_MAX_PHYS	9
>  #define HISI_SAS_MAX_QUEUES	32
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

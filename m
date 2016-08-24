From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 8/8] hisi_sas: update version to 1.6
Date: Wed, 24 Aug 2016 15:00:57 +0200
Message-ID: <28393b3b-d0ab-eda8-fa1c-8b2bfef52a54@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-9-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-9-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 8311360..ca55ec2 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -23,7 +23,7 @@
>  #include <scsi/sas_ata.h>
>  #include <scsi/libsas.h>
>  
> -#define DRV_VERSION "v1.5"
> +#define DRV_VERSION "v1.6"
>  
>  #define HISI_SAS_MAX_PHYS	9
>  #define HISI_SAS_MAX_QUEUES	32
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

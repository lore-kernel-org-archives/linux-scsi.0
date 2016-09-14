From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] hisi_sas: add missing SATA pending device type to
 v2 hw
Date: Wed, 14 Sep 2016 14:51:16 +0200
Message-ID: <26cbe3ca-43ec-ce43-92f8-67d905b3d983@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-15-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-15-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> In setup_itct_v2_hw(), SATA device type SAS_SATA_PENDING
> is missing, so add it.
> 
> Note: The HiSi SAS controller does not support SATA PM,
>       so do not handle SAS_SATA_PM_PORT or SAS_SATA_PM.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 5925b93..735ebff 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -594,6 +594,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
>  		qw0 = HISI_SAS_DEV_TYPE_SSP << ITCT_HDR_DEV_TYPE_OFF;
>  		break;
>  	case SAS_SATA_DEV:
> +	case SAS_SATA_PENDING:
>  		if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
>  			qw0 = HISI_SAS_DEV_TYPE_STP << ITCT_HDR_DEV_TYPE_OFF;
>  		else
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

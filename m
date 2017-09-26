From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: remove unused variable sas_ha
Date: Tue, 26 Sep 2017 15:38:26 +0100
Message-ID: <ed1c0302-d775-b5b7-8b64-f6e0c68350dd@huawei.com>
References: <20170926191750.25444-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926191750.25444-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, yanaijie@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 26/09/2017 20:17, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Remove unused variable sas_ha to clean up build warning
> "unused variable ‘sas_ha’ [-Wunused-variable]"
>
> Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: John Garry <john.garry@huawei.com>

> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 29d6cb39299c..9e2990268f00 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1046,7 +1046,6 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
>
>  static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
>  {
> -	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
>  	struct device *dev = hisi_hba->dev;
>  	struct Scsi_Host *shost = hisi_hba->shost;
>  	u32 old_state, state;
>

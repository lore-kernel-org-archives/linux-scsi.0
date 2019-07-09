From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: libsas: remove the exporting of sas_wait_eh
Date: Tue, 9 Jul 2019 09:58:50 +0800
Message-ID: <00489583-ff52-d9b7-5e46-478aa361758e@huawei.com>
References: <20190708164339.14465-1-efremov@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190708164339.14465-1-efremov@linux.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Efremov <efremov@linux.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 2019/7/9 0:43, Denis Efremov wrote:
> The function sas_wait_eh is declared static and marked
> EXPORT_SYMBOL, which is at best an odd combination. Because the
> function is not used outside of the drivers/scsi/libsas/sas_scsi_host.c
> file it is defined in, this commit removes the EXPORT_SYMBOL() marking.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>   drivers/scsi/libsas/sas_scsi_host.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index ede0674d8399..5564d3f1243a 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -414,7 +414,6 @@ static void sas_wait_eh(struct domain_device *dev)
>   		goto retry;
>   	}
>   }
> -EXPORT_SYMBOL(sas_wait_eh);
>   
>   static int sas_queue_reset(struct domain_device *dev, int reset_type,
>   			   u64 lun, int wait)
> 

Reviewed-by: Jason Yan <yanaijie@huawei.com>

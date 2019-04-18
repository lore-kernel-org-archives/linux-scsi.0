From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH -next] scsi: lpfc: Make lpfc_sli4_oas_verify static
Date: Thu, 18 Apr 2019 08:50:23 -0700
Message-ID: <f6461bd3-dae0-9520-f5f7-01e48338df01@broadcom.com>
References: <20190417150554.34844-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417150554.34844-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/2019 8:05 AM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fix sparse warning:
>
> drivers/scsi/lpfc/lpfc_init.c:13091:1: warning:
>   symbol 'lpfc_sli4_oas_verify' was not declared. Should it be static?
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 8e0de48..eaaef68 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -13087,7 +13087,7 @@ lpfc_io_resume(struct pci_dev *pdev)
>    * is destroyed.
>    *
>    **/
> -void
> +static void
>   lpfc_sli4_oas_verify(struct lpfc_hba *phba)
>   {
>   

Looks good. Interesting as there's a prototype for the function earlier 
which defines it as static.

Reviewed-by:  James Smart  <james.smart@broadcom.com>

-- james

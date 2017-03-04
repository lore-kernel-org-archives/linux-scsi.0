From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment of sgel
Date: Sat, 4 Mar 2017 09:42:31 -0800
Message-ID: <7eb92880-0cd8-3260-a890-8ef970ef2568@broadcom.com>
References: <20170224134523.5385-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224134523.5385-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good. I included it in the lpfc patch set just posted.

-- james



On 2/24/2017 5:45 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> In the NVMET_FCOP_RSP case, sgel is assigned but never used and
> hence is redundant and can be removed.
>
> Detected by CoverityScan, CID#1411658 ("Unused value")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index c421e17..e59a0a8 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1445,7 +1445,6 @@ lpfc_nvmet_prep_fcp_wqe(struct lpfc_hba *phba,
>   
>   	case NVMET_FCOP_RSP:
>   		/* Words 0 - 2 */
> -		sgel = &rsp->sg[0];
>   		physaddr = rsp->rspdma;
>   		wqe->fcp_trsp.bde.tus.f.bdeFlags = BUFF_TYPE_BDE_64;
>   		wqe->fcp_trsp.bde.tus.f.bdeSize = rsp->rsplen;

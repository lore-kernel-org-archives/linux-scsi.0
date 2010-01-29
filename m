From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] lpfc: Positive error return into negative
Date: Fri, 29 Jan 2010 14:31:02 -0500
Message-ID: <4B633776.6060404@emulex.com>
References: <4B62B3C6.5090903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754252Ab0A2Tb0@vger.kernel.org>
In-Reply-To: <4B62B3C6.5090903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is innoculous as the code really only cares whether it's zero or 
non-zero. But, there's no harm in being consistent.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


Roel Kluin wrote:
> In the comment on top of lpfc_sli_hbq_setup() and of its caller which
> transmits this error, lpfc_sli_hba_setup(), it is stated that the
> function should return a negative error code.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 589549b..a960736 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -3709,7 +3709,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
>  
>  			phba->link_state = LPFC_HBA_ERROR;
>  			mempool_free(pmb, phba->mbox_mem_pool);
> -			return ENXIO;
> +			return -ENXIO;
>  		}
>  	}
>  	phba->hbq_count = hbq_count;
>
>   

From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 12/13] pmcraid: Get rid of a redundant assignment
Date: Thu, 21 Aug 2014 13:33:52 +0200
Message-ID: <53F5D920.1080800@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com> <8058dca6525ca29845019ea9922c37f3416c0c7a.1408335523.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8058dca6525ca29845019ea9922c37f3416c0c7a.1408335523.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/pmcraid.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 6f3275d..6e575ed 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4746,7 +4746,6 @@ pmcraid_isr_legacy:
>  	pinstance->hrrq_vector[0].drv_inst = pinstance;
>  	pinstance->hrrq_vector[0].vector = pdev->irq;
>  	pinstance->num_hrrq = 1;
> -	rc = 0;
>  
>  	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
>  			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

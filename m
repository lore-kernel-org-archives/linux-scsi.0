From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: megaraid_sas: add in missing white space in error
 message text
Date: Wed, 14 Sep 2016 15:23:00 +0200
Message-ID: <5a21833c-2e85-2092-f9a8-b3d023b03485@suse.de>
References: <20160912124212.32132-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912124212.32132-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/12/2016 02:42 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A dev_printk message spans two lines and the literal string is missing
> a white space between words. Add the white space.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 2d62d71..c236c4d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5782,7 +5782,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
>  					     &instance->consumer_h);
>  
>  		if (!instance->producer || !instance->consumer) {
> -			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
> +			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
>  			       "memory for producer, consumer\n");
>  			goto fail_alloc_dma_buf;
>  		}
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

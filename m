From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 03/11] hpsa: correct static checker warnings on driver
 init cleanup
Date: Wed, 22 Jul 2015 17:16:45 +0200
Message-ID: <55AFB3DD.7080205@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161233.31955.63909.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbbGVPQs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:16:48 -0400
In-Reply-To: <20150718161233.31955.63909.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:12, Don Brace wrote:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/hpsa.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e9b2073..6b083af 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8053,7 +8053,7 @@ reinit_after_soft_reset:
>  		rc = hpsa_kdump_soft_reset(h);
>  		if (rc)
>  			/* Neither hard nor soft reset worked, we're hosed. */
> -			goto clean9;
> +			goto clean7;
>  
>  		dev_info(&h->pdev->dev, "Board READY.\n");
>  		dev_info(&h->pdev->dev,
> @@ -8099,8 +8099,6 @@ reinit_after_soft_reset:
>  				h->heartbeat_sample_interval);
>  	return 0;
>  
> -clean9: /* wq, sh, perf, sg, cmd, irq, shost, pci, lu, aer/h */
> -	kfree(h->hba_inquiry_data);
>  clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
>  	hpsa_free_performant_mode(h);
>  	h->access.set_intr_mask(h, HPSA_INTR_OFF);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


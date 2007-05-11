From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 18/28] scsi/lpfc/lpfc_init.c: remove unused variable
Date: Fri, 11 May 2007 08:40:59 -0400
Message-ID: <4644645B.6010404@emulex.com>
References: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52550 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbXEKMs4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 08:48:56 -0400
In-Reply-To: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, bunk@stusta.de

ACK

-- james s

akpm@linux-foundation.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/lpfc/lpfc_init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable drivers/scsi/lpfc/lpfc_init.c
> --- a/drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable
> +++ a/drivers/scsi/lpfc/lpfc_init.c
> @@ -1512,7 +1512,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>  	struct lpfc_sli  *psli;
>  	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
>  	unsigned long bar0map_len, bar2map_len;
> -	int error = -ENODEV, retval;
> +	int error = -ENODEV;
>  	int i;
>  	uint16_t iotag;
>  
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

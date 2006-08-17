From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [RFC][PATCH 38/75] scsi: drivers/scsi/megaraid.c pci_module_init to pci_register_driver conversion
Date: Thu, 17 Aug 2006 14:59:56 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E351@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23487 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932216AbWHQU76 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 16:59:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

ACK - pci_module_init is obsolete.

Thank you,

Seokmann

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Michal 
> Piotrowski
> Sent: Thursday, August 17, 2006 9:28 AM
> To: Kolli, Neela
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: [RFC][PATCH 38/75] scsi: drivers/scsi/megaraid.c 
> pci_module_init to pci_register_driver conversion
> 
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> diff -uprN -X linux-work/Documentation/dontdiff 
> linux-work-clean/drivers/scsi/megaraid.c 
> linux-work2/drivers/scsi/megaraid.c
> --- linux-work-clean/drivers/scsi/megaraid.c	2006-08-16 
> 22:41:17.000000000 +0200
> +++ linux-work2/drivers/scsi/megaraid.c	2006-08-17 
> 05:21:04.000000000 +0200
> @@ -5078,7 +5078,7 @@ static int __init megaraid_init(void)
>  				"megaraid: failed to create 
> megaraid root\n");
>  	}
>  #endif
> -	error = pci_module_init(&megaraid_pci_driver);
> +	error = pci_register_driver(&megaraid_pci_driver);
>  	if (error) {
>  #ifdef CONFIG_PROC_FS
>  		remove_proc_entry("megaraid", &proc_root);
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

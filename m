From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [patch 05/11] drivers/scsi/*: convert to pci_register_driver
Date: Mon, 7 Mar 2005 14:00:30 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703662729@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:34967 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261228AbVCGTD7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 14:03:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'domen@coderock.org'" <domen@coderock.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, c.lucas@ifrance.com

On Sunday, March 06, 2005 5:27 PM, Domen wrote:
> diff -puN drivers/scsi/megaraid.c~pci_register_driver-drivers_scsi
> drivers/scsi/megaraid.c
> --- kj/drivers/scsi/megaraid.c~pci_register_driver-drivers_scsi
2005-03-
> 05 16:12:48.000000000 +0100
> +++ kj-domen/drivers/scsi/megaraid.c	2005-03-05 16:12:49.000000000
> +0100
> @@ -5079,7 +5079,7 @@ static int __init megaraid_init(void)
>  				"megaraid: failed to create megaraid
root\n");
>  	}
>  #endif
> -	error = pci_module_init(&megaraid_pci_driver);
> +	error = pci_register_driver(&megaraid_pci_driver);
>  	if (error) {
>  #ifdef CONFIG_PROC_FS
>  		remove_proc_entry("megaraid", &proc_root);
Thank you for help.
The driver will be modified accordingly.

Seokmann 
LSI Logic Corporation

kernel.org/majordomo-info.html

From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: [patch 1/1] megaraid: Add AMI Megaraid card to new driver
Date: Thu, 3 Feb 2005 10:34:33 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570366266A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34277 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263155AbVBCPeh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2005 10:34:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'brking@charter.net'" <brking@charter.net>
Cc: "Doelfel, Hardy" <hdoelfel@lsil.com>, linux-scsi@vger.kernel.org

On Tuesday, January 18, 2005 10:39 PM, Brian wrote:
> Adds AMI Megaraid Elite 1600 to the list of supported
> adapters. I encountered some issues running with the old
> megaraid driver with this card, so I wrote this patch and
> have been running without problems since mid December.
> Please apply.

It has been added to the driver since 2.20.4.3.

Thanks,

Seokmann
LSI Logic Corporation.

> -----Original Message-----
> From: brking@charter.net [mailto:brking@charter.net]
> Sent: Tuesday, January 18, 2005 10:39 PM
> To: Atul.Mukker@lsil.com
> Cc: linux-scsi@vger.kernel.org; brking@charter.net
> Subject: [patch 1/1] megaraid: Add AMI Megaraid card to new driver
> 
> 
> 
> Adds AMI Megaraid Elite 1600 to the list of supported
> adapters. I encountered some issues running with the old
> megaraid driver with this card, so I wrote this patch and
> have been running without problems since mid December.
> Please apply.
> 
> Here is the PCI config space dump of my controller:
> 
> 0000:03:00.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev
> 02)
> 00: 1e 10 60 19 16 00 90 22 02 00 04 01 08 40 00 00
> 10: 08 00 00 d0 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 1e 10 93 04
> 30: 00 00 df df 80 00 00 00 00 00 00 00 0a 01 00 00
> 
> Signed-off-by: <brking@charter.net>
> ---
> 
> 
> diff -puN drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc
> drivers/scsi/megaraid/megaraid_mbox.c
> --- linux-2.6.11-rc1-
> bk6/drivers/scsi/megaraid/megaraid_mbox.c~megaraid_ami_perc3dc
2005-01-
> 18 18:23:57.000000000 -0600
> +++ linux-2.6.11-rc1-bk6-brking/drivers/scsi/megaraid/megaraid_mbox.c
> 	2005-01-18 18:23:57.000000000 -0600
> @@ -301,6 +301,12 @@ static struct pci_device_id pci_id_table
>  		PCI_SUBSYS_ID_PERC3_SC,
>  	},
>  	{
> +		PCI_VENDOR_ID_AMI,
> +		PCI_DEVICE_ID_AMI_MEGARAID3,
> +		PCI_VENDOR_ID_AMI,
> +		PCI_SUBSYS_ID_PERC3_DC,
> +	},
> +	{
>  		PCI_VENDOR_ID_LSI_LOGIC,
>  		PCI_DEVICE_ID_MEGARAID_SCSI_320_0,
>  		PCI_VENDOR_ID_LSI_LOGIC,
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: dmx3191d: use module_pci_driver
Date: Thu, 17 Nov 2016 09:56:45 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611170954190.25297@nippy.intranet>
References: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com> <015ae0a9f5aea965329a6669367ee7a61089ef6b.1479278839.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44992 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933150AbcKPW4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 17:56:12 -0500
In-Reply-To: <015ae0a9f5aea965329a6669367ee7a61089ef6b.1479278839.git.geliangtang@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Wed, 16 Nov 2016, Geliang Tang wrote:

> Use module_pci_driver() helper to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Acked-by: Finn Thain <fthain@telegraphics.com.au>

> ---
>  drivers/scsi/dmx3191d.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
> index 3aa4657..6af3394 100644
> --- a/drivers/scsi/dmx3191d.c
> +++ b/drivers/scsi/dmx3191d.c
> @@ -153,18 +153,7 @@ static struct pci_driver dmx3191d_pci_driver = {
>  	.remove		= dmx3191d_remove_one,
>  };
>  
> -static int __init dmx3191d_init(void)
> -{
> -	return pci_register_driver(&dmx3191d_pci_driver);
> -}
> -
> -static void __exit dmx3191d_exit(void)
> -{
> -	pci_unregister_driver(&dmx3191d_pci_driver);
> -}
> -
> -module_init(dmx3191d_init);
> -module_exit(dmx3191d_exit);
> +module_pci_driver(dmx3191d_pci_driver);
>  
>  MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
>  MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
> 

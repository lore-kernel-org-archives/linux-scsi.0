From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [patch 2/2] megaraid_sas: missing curly braces in megasas_detach_one()
Date: Tue, 10 Nov 2015 15:49:25 +0530
Message-ID: <5e96883ecfca1464351bf64da1ae723c@mail.gmail.com>
References: <20151107161709.GB30686@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20151107161709.GB30686@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Saturday, November 07, 2015 9:47 PM
> To: Kashyap Desai; Sumit Saxena
> Cc: Uday Lingala; James E.J. Bottomley; megaraidlinux.pdl@avagotech.com;
> linux-scsi@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 2/2] megaraid_sas: missing curly braces in
> megasas_detach_one()
>
> The indenting indicates that there are supposed to be some curly braces
> here.  Presumably it means we free something unintentionally leading to
a
> use after free.

NACK. Indentation is wrong. We don't need to add braces. We will fix
indentation and resend patch. Since this is not critical, let's ignore for
now.
>
> Fixes: 3761cb4cf65e ('megaraid_sas: JBOD sequence number support')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested.
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 829e9e9..91e200d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5932,7 +5932,7 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
>  						  fusion->max_map_sz,
>  						  fusion->ld_map[i],
>  						  fusion->ld_map_phys[i]);
> -			if (fusion->ld_drv_map[i])
> +			if (fusion->ld_drv_map[i]) {
>  				free_pages((ulong)fusion->ld_drv_map[i],
>  					fusion->drv_map_pages);
>  				if (fusion->pd_seq_sync)
> @@ -5940,6 +5940,7 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
>  						pd_seq_map_sz,
>  						fusion->pd_seq_sync[i],
>  						fusion->pd_seq_phys[i]);
> +			}
>  		}
>  		free_pages((ulong)instance->ctrl_context,
>  			instance->ctrl_context_pages);

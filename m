From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [patch 1/2] megaraid_sas: remove a stray tab
Date: Tue, 10 Nov 2015 15:51:44 +0530
Message-ID: <fa20b992d4c9f74d290d7d842386faf1@mail.gmail.com>
References: <20151107161615.GA30686@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151107161615.GA30686@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Saturday, November 07, 2015 9:46 PM
> To: Kashyap Desai; Sumit Saxena
> Cc: Uday Lingala; James E.J. Bottomley; megaraidlinux.pdl@avagotech.com;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [patch 1/2] megaraid_sas: remove a stray tab
>
> One line was indented more than the others.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Let us combine your next patch (because that is also indentation issue)
and this one. We will resubmit patch.   For now ignore to avoid any issue
for pending patches to be committed.

>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index cc95372..829e9e9 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5923,9 +5923,9 @@ static void megasas_detach_one(struct pci_dev
> *pdev)
>
>  	if (instance->ctrl_context) {
>  		megasas_release_fusion(instance);
> -			pd_seq_map_sz = sizeof(struct
> MR_PD_CFG_SEQ_NUM_SYNC) +
> +		pd_seq_map_sz = sizeof(struct
> MR_PD_CFG_SEQ_NUM_SYNC) +
>  				(sizeof(struct MR_PD_CFG_SEQ) *
> -					(MAX_PHYSICAL_DEVICES - 1));
> +				(MAX_PHYSICAL_DEVICES - 1));
>  		for (i = 0; i < 2 ; i++) {
>  			if (fusion->ld_map[i])
>  				dma_free_coherent(&instance->pdev->dev,

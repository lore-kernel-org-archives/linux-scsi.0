From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid: fix spelling mistake "maibox" -> "mailbox"
Date: Wed, 26 Sep 2018 16:49:10 +0530
Message-ID: <2517be92121ace5f4a42276bce2a413b@mail.gmail.com>
References: <20180923222548.7908-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180923222548.7908-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Colin King [mailto:colin.king@canonical.com]
> Sent: Monday, September 24, 2018 3:56 AM
> To: Kashyap Desai <kashyap.desai@broadcom.com>; Sumit Saxena
> <sumit.saxena@broadcom.com>; Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com>; James E . J . Bottomley
> <jejb@linux.vnet.ibm.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; megaraidlinux.pdl@broadcom.com; linux-
> scsi@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: megaraid: fix spelling mistake "maibox" ->
> "mailbox"
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in warning message and comments
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/megaraid/megaraid_mbox.c | 4 ++--
> drivers/scsi/megaraid/megaraid_mbox.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
> b/drivers/scsi/megaraid/megaraid_mbox.c
> index 530358cdcb39..2013523605c5 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -484,7 +484,7 @@ megaraid_probe_one(struct pci_dev *pdev, const
> struct pci_device_id *id)
>  	// Start the mailbox based controller
>  	if (megaraid_init_mbox(adapter) != 0) {
>  		con_log(CL_ANN, (KERN_WARNING
> -			"megaraid: maibox adapter did not initialize\n"));
> +			"megaraid: mailbox adapter did not initialize\n"));
>
>  		goto out_free_adapter;
>  	}
> @@ -950,7 +950,7 @@ megaraid_fini_mbox(adapter_t *adapter)
>   * megaraid_alloc_cmd_packets - allocate shared mailbox
>   * @adapter		: soft state of the raid controller
>   *
> - * Allocate and align the shared mailbox. This maibox is used to issue
> + * Allocate and align the shared mailbox. This mailbox is used to issue
>   * all the commands. For IO based controllers, the mailbox is also
> registered
>   * with the FW. Allocate memory for all commands as well.
>   * This is our big allocator.
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.h
> b/drivers/scsi/megaraid/megaraid_mbox.h
> index c1d86d961a92..e075aeb4012f 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.h
> +++ b/drivers/scsi/megaraid/megaraid_mbox.h
> @@ -117,7 +117,7 @@
>   * @raw_mbox		: raw mailbox pointer
>   * @mbox		: mailbox
>   * @mbox64		: extended mailbox
> - * @mbox_dma_h		: maibox dma address
> + * @mbox_dma_h		: mailbox dma address
>   * @sgl64		: 64-bit scatter-gather list
>   * @sgl32		: 32-bit scatter-gather list
>   * @sgl_dma_h		: dma handle for the scatter-gather list

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> --
> 2.17.1

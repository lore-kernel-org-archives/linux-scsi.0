From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/2] hisi_sas: SCSI_HISI_SAS should depend on HAS_DMA
Date: Tue, 19 Jan 2016 09:47:05 +0000
Message-ID: <569E0619.6020809@huawei.com>
References: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15/01/2016 13:39, Geert Uytterhoeven wrote:
> If NO_DMA=y:
>
>      ERROR: "dma_map_sg" [drivers/scsi/hisi_sas/hisi_sas_v1_hw.ko] undefined!
>      ERROR: "dma_pool_alloc" [drivers/scsi/hisi_sas/hisi_sas_v1_hw.ko] undefined!
>      ERROR: "dma_unmap_sg" [drivers/scsi/hisi_sas/hisi_sas_v1_hw.ko] undefined!
>      ERROR: "dma_unmap_sg" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_set_mask" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_map_sg" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_destroy" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_free_coherent" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_free" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_alloc_coherent" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_alloc" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_supported" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>      ERROR: "dma_pool_create" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
>
> Add a dependency on HAS_DMA to fix this.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/scsi/hisi_sas/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index 37a0c7156087905b..2c05021636a5fea6 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -1,5 +1,6 @@
>   config SCSI_HISI_SAS
>   	tristate "HiSilicon SAS"
> +	depends on HAS_DMA
>   	select SCSI_SAS_LIBSAS
>   	select BLK_DEV_INTEGRITY
>   	help
>

Reviewed-by: John Garry <john.garry@huawei.com>

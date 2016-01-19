From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/2] hisi_sas: Restrict SCSI_HISI_SAS to arm64
Date: Tue, 19 Jan 2016 09:56:17 +0000
Message-ID: <569E0841.4000003@huawei.com>
References: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
 <1452865149-32064-2-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452865149-32064-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15/01/2016 13:39, Geert Uytterhoeven wrote:
> The HiSilicon SAS HBA is available in HiSilicon arm64 SoCs only.
> Restrict it to arm64, unless compile-testing.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/scsi/hisi_sas/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
> index 2c05021636a5fea6..b67661836c9fa26f 100644
> --- a/drivers/scsi/hisi_sas/Kconfig
> +++ b/drivers/scsi/hisi_sas/Kconfig
> @@ -1,6 +1,7 @@
>   config SCSI_HISI_SAS
>   	tristate "HiSilicon SAS"
>   	depends on HAS_DMA
> +	depends on ARM64 || COMPILE_TEST
>   	select SCSI_SAS_LIBSAS
>   	select BLK_DEV_INTEGRITY
>   	help
>

Reviewed-by: John Garry <john.garry@huawei.com>

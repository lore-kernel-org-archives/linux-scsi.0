From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v2] drivers: ufs: Add missing MODULE_* information
Date: Thu, 21 Mar 2019 21:28:39 +0800
Message-ID: <1553174919.30977.86.camel@mtkswgap22>
References: <20190321132444.28659-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321132444.28659-1-anders.roxell@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Anders,

On Thu, 2019-03-21 at 14:24 +0100, Anders Roxell wrote:
> When building the ufs-mediatek module the following warning shows up:
> 
> WARNING: modpost: missing MODULE_LICENSE() in
>   drivers/scsi/ufs/ufs-mediatek.o
> 
> Rework to add MODULE_LICENSE,MODULE_AUTHOR and MODULE_DESCRIPTION.
> 
> Fixes: ddd90623ce26 ("scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index c3b78fc83d3f..5e3bda42ac3b 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -364,4 +364,9 @@ static struct platform_driver ufs_mtk_pltform = {
>  	},
>  };
>  
> +MODULE_AUTHOR("Stanley Chu <stanley.chu@mediatek.com>");
> +MODULE_AUTHOR("Peter Wang <peter.wang@mediatek.com>");
> +MODULE_DESCRIPTION("MediaTek UFS Host Driver");
> +MODULE_LICENSE("GPL v2");
> +
>  module_platform_driver(ufs_mtk_pltform);


Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>


Thanks,
Stanley

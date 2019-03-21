From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH] drivers: ufs: Add missing MODULE_* information
Date: Thu, 21 Mar 2019 21:18:21 +0800
Message-ID: <1553174301.30977.85.camel@mtkswgap22>
References: <20190321125034.22697-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190321125034.22697-1-anders.roxell@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Anders Roxell <anders.roxell@linaro.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Anders,

On Thu, 2019-03-21 at 13:50 +0100, Anders Roxell wrote:
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
> index c3b78fc83d3f..ce4767784937 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -364,4 +364,9 @@ static struct platform_driver ufs_mtk_pltform = {
>  	},
>  };
>  
> +MODULE_AUTHOR("Stanley Chu <stanley.chu@mediatek.com>");
> +MODULE_AUTHOR("Peter Wang <peter.wang@mediatek.com>");
> +MODULE_DESCRIPTION("Mediatek UFS Driver");

Thanks for sending this.

Could you fix it as "MediaTek UFS Host Driver" ?

> +MODULE_LICENSE("GPL v2");
> +
>  module_platform_driver(ufs_mtk_pltform);

Thanks,
Stanley

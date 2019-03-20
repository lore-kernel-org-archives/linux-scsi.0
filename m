From: Mukesh Ojha <mojha@codeaurora.org>
Subject: Re: [PATCH -next] scsi: ufs-mediatek: Make some symbols static
Date: Thu, 21 Mar 2019 01:00:52 +0530
Message-ID: <d0536ff3-c6aa-ae3d-49cd-1a54a8dce5b5@codeaurora.org>
References: <20190320142458.20052-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190320142458.20052-1-yuehaibing@huawei.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Yue Haibing <yuehaibing@huawei.com>, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com, matthias.bgg@gmail.com, stanley.chu@mediatek.com
Cc: linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 3/20/2019 7:54 PM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fix sparse warnings:
>
> drivers/scsi/ufs/ufs-mediatek.c:19:6: warning: symbol 'ufs_mtk_cfg_unipro_cg' was not declared. Should it be static?
> drivers/scsi/ufs/ufs-mediatek.c:55:5: warning: symbol 'ufs_mtk_bind_mphy' was not declared. Should it be static?
> drivers/scsi/ufs/ufs-mediatek.c:342:27: warning: symbol 'ufs_mtk_of_match' was not declared. Should it be static?
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/ufs/ufs-mediatek.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index c3b78fc..2fbb450 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -16,7 +16,7 @@
>   #include "unipro.h"
>   #include "ufs-mediatek.h"
>   
> -void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
> +static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
>   {
>   	u32 tmp;
>   
> @@ -52,7 +52,7 @@ void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
>   	}
>   }
>   
> -int ufs_mtk_bind_mphy(struct ufs_hba *hba)
> +static int ufs_mtk_bind_mphy(struct ufs_hba *hba)
>   {
>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>   	struct device *dev = hba->dev;
> @@ -339,7 +339,7 @@ static int ufs_mtk_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -const struct of_device_id ufs_mtk_of_match[] = {
> +static const struct of_device_id ufs_mtk_of_match[] = {
>   	{ .compatible = "mediatek,mt8183-ufshci"},
>   	{},
>   };


Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>


Cheers,
Mukesh
